/*
 *   Copyright © 2021 Reion Wong <reionwong@gmail.com>
 *   Copyright © 2021 Reven Martin <revenmartin@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *   General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; see the file COPYING.  if not, write to
 *   the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *   Boston, MA 02110-1301, USA.
 */

#include "roundedwindow.h"

// Qt
#include <QFile>
#include <QPainter>
#include <QPainterPath>
#include <QRegion>
#include <QDebug>

#include <QSettings>

Q_DECLARE_METATYPE(QPainterPath)

typedef void (* SetDepth)(void *, int);
static SetDepth setDepthfunc = nullptr;

static QStringList allowList = { "netease-cloud-music netease-cloud-music",
                                 "com.alibabainc.dingtalk com.alibabainc.dingtalk",
                                 "tenvideo_universal tenvideo_universal",
                                 "com.eusoft.ting.en com.eusoft.ting.en",
                                 "i4toolslinux i4tools",
                                 "youku-app youku-app",
                                 "qqmusic qqmusic",
                                 "mytime mytime",
                                 "feishu feishu",
                                 "bytedance-feishu bytedance-feishu",
                                 "xmind xmind",
                                 "mtxx mtxx",
                                 "ynote-desktop ynote-desktop",

                                 // Open source software
                                 "code code",
                                 "motrix motrix"
                               };

// From ubreffect
static KWin::GLShader *getShader()
{
    // copy from kwinglutils.cpp
    QByteArray source;
    QTextStream stream(&source);

    KWin::GLPlatform * const gl = KWin::GLPlatform::instance();
    QByteArray varying, output, textureLookup;

    if (!gl->isGLES()) {
        const bool glsl_140 = gl->glslVersion() >= KWin::kVersionNumber(1, 40);

        if (glsl_140)
            stream << "#version 140\n\n";

        varying       = glsl_140 ? QByteArrayLiteral("in")         : QByteArrayLiteral("varying");
        textureLookup = glsl_140 ? QByteArrayLiteral("texture")    : QByteArrayLiteral("texture2D");
        output        = glsl_140 ? QByteArrayLiteral("fragColor")  : QByteArrayLiteral("gl_FragColor");
    } else {
        const bool glsl_es_300 = KWin::GLPlatform::instance()->glslVersion() >= KWin::kVersionNumber(3, 0);

        if (glsl_es_300)
            stream << "#version 300 es\n\n";

        // From the GLSL ES specification:
        //
        //     "The fragment language has no default precision qualifier for floating point types."
        stream << "precision highp float;\n\n";

        varying       = glsl_es_300 ? QByteArrayLiteral("in")         : QByteArrayLiteral("varying");
        textureLookup = glsl_es_300 ? QByteArrayLiteral("texture")    : QByteArrayLiteral("texture2D");
        output        = glsl_es_300 ? QByteArrayLiteral("fragColor")  : QByteArrayLiteral("gl_FragColor");
    }

    KWin::ShaderTraits traits;

    traits |= KWin::ShaderTrait::MapTexture;
    traits |= KWin::ShaderTrait::Modulate;
    traits |= KWin::ShaderTrait::AdjustSaturation;

    if (traits & KWin::ShaderTrait::MapTexture) {
        stream << "uniform sampler2D sampler;\n";

        // custom texture
        stream << "uniform sampler2D topleft;\n";
        stream << "uniform sampler2D topright;\n";
        stream << "uniform sampler2D bottomleft;\n";
        stream << "uniform sampler2D bottomright;\n";

        // scale
        stream << "uniform vec2 scale;\n";
        stream << "uniform vec2 scale1;\n";
        stream << "uniform vec2 scale2;\n";
        stream << "uniform vec2 scale3;\n";

        if (traits & KWin::ShaderTrait::Modulate)
            stream << "uniform vec4 modulation;\n";
        if (traits & KWin::ShaderTrait::AdjustSaturation)
            stream << "uniform float saturation;\n";

        stream << "\n" << varying << " vec2 texcoord0;\n";

    } else if (traits & KWin::ShaderTrait::UniformColor)
        stream << "uniform vec4 geometryColor;\n";

    #if KWIN_EFFECT_API_VERSION < 233
    if (traits & KWin::ShaderTrait::ClampTexture) {
        stream << "uniform vec4 textureClamp;\n";
    }
    #endif

    if (output != QByteArrayLiteral("gl_FragColor"))
        stream << "\nout vec4 " << output << ";\n";

    stream << "\nvoid main(void)\n{\n";
    if (traits & KWin::ShaderTrait::MapTexture) {
        stream << "vec2 texcoordC = texcoord0;\n";


        stream << "    " << "vec4 var;\n";
        stream << "if (texcoordC.x < 0.5) {\n"
                  "    if (texcoordC.y < 0.5) {\n"
                  "        vec2 cornerCoord = vec2(texcoordC.x * scale.x, texcoordC.y * scale.y);\n"
                  "        var = " << textureLookup << "(topleft, cornerCoord);\n"
                  "    } else {\n"
                  "        vec2 cornerCoordBL = vec2(texcoordC.x * scale2.x, (1.0 - texcoordC.y) * scale2.y);\n"
                  "        var = " << textureLookup << "(bottomleft, cornerCoordBL);\n"
                  "    }\n"
                  "} else {\n"
                  "    if (texcoordC.y < 0.5) {\n"
                  "        vec2 cornerCoordTR = vec2((1.0 - texcoordC.x) * scale1.x, texcoordC.y * scale1.y);\n"
                  "        var = " << textureLookup << "(topright, cornerCoordTR);\n"
                  "    } else {\n"
                  "        vec2 cornerCoordBR = vec2((1.0 - texcoordC.x) * scale3.x, (1.0 - texcoordC.y) * scale3.y);\n"
                  "        var = " << textureLookup << "(bottomright, cornerCoordBR);\n"
                  "    }\n"
                  "}\n";

        stream << "    vec4 texel = " << textureLookup << "(sampler, texcoordC);\n";
        if (traits & KWin::ShaderTrait::Modulate)
            stream << "    texel *= modulation;\n";
        if (traits & KWin::ShaderTrait::AdjustSaturation)
            stream << "    texel.rgb = mix(vec3(dot(texel.rgb, vec3(0.2126, 0.7152, 0.0722))), texel.rgb, saturation);\n";

        stream << "    " << output << " = texel * var;\n";
    } else if (traits & KWin::ShaderTrait::UniformColor)
        stream << "    " << output << " = geometryColor;\n";

    stream << "}";
    stream.flush();

    auto shader = KWin::ShaderManager::instance()->generateCustomShader(traits, QByteArray(), source);
    //shaders.insert(direction, shader);
    return shader;
}

static KWin::GLTexture *getTexture(int borderRadius)
{
    QPixmap pix(QSize(borderRadius, borderRadius));
    pix.fill(Qt::transparent);
    QPainter painter(&pix);
    painter.setRenderHint(QPainter::Antialiasing);
    QPainterPath path;
    path.moveTo(borderRadius, 0);
    path.arcTo(0, 0, 2 * borderRadius, 2 * borderRadius, 90, 90);
    path.lineTo(borderRadius, borderRadius);
    path.lineTo(borderRadius, 0);
    painter.fillPath(path, Qt::white);

    auto texture = new KWin::GLTexture(pix);
    texture->setFilter(GL_LINEAR);
    texture->setWrapMode(GL_CLAMP_TO_BORDER);

    return texture;
}

RoundedWindow::RoundedWindow(QObject *, const QVariantList &)
    : KWin::Effect()
{
    QSettings settings(QSettings::UserScope, "cuteos", "theme");
    qreal devicePixelRatio = settings.value("PixelRatio", 1.0).toReal();
    m_frameRadius = 11 * devicePixelRatio;

    setDepthfunc = (SetDepth) QLibrary::resolve("kwin.so." + qApp->applicationVersion(), "_ZN4KWin8Toplevel8setDepthEi");

    QString name = "_NET_WM_STATE";
    xcb_intern_atom_cookie_t cookie = xcb_intern_atom_unchecked(KWin::connection(), false, name.length(), name.toUtf8());
    xcb_intern_atom_reply_t *reply = xcb_intern_atom_reply(KWin::connection(), cookie, nullptr);
    m_netWMStateAtom = reply->atom;
    free(reply);

    name = "_NET_WM_STATE_MAXIMIZED_HORZ";
    cookie = xcb_intern_atom_unchecked(KWin::connection(), false, name.length(), name.toUtf8());
    reply = xcb_intern_atom_reply(KWin::connection(), cookie, nullptr);
    m_netWMStateMaxHorzAtom = reply->atom;
    free(reply);

    name = "_NET_WM_STATE_MAXIMIZED_VERT";
    cookie = xcb_intern_atom_unchecked(KWin::connection(), false, name.length(), name.toUtf8());
    reply = xcb_intern_atom_reply(KWin::connection(), cookie, nullptr);
    m_netWMStateMaxVertAtom = reply->atom;
    free(reply);

    m_shader = getShader();
    m_texure = getTexture(m_frameRadius);
}

RoundedWindow::~RoundedWindow()
{
}

bool RoundedWindow::supported()
{
    const QByteArray desktop = qgetenv("XDG_CURRENT_DESKTOP");

    if (desktop.isEmpty())
        return false;

    return desktop == "Cute" && KWin::effects->isOpenGLCompositing() && KWin::GLRenderTarget::supported();
}

bool RoundedWindow::enabledByDefault()
{
    return supported();
}

#if KWIN_EFFECT_API_VERSION < 233
bool RoundedWindow::hasShadow(KWin::WindowQuadList &qds)
{
    for (int i = 0; i < qds.count(); ++i)
        if (qds.at(i).type() == KWin::WindowQuadShadow)
            return true;

    return false;
}
#endif

bool RoundedWindow::isMaximized(KWin::EffectWindow *w)
{
    if (m_netWMStateAtom == 0)
        return false;

    QByteArray rawAtomData = w->readProperty(m_netWMStateAtom, XCB_ATOM_ATOM, 32);
    if (!rawAtomData.isEmpty()) {
        for (int i = 0; i < rawAtomData.length(); i += sizeof(xcb_atom_t)) {
            xcb_atom_t atom = static_cast<xcb_atom_t>(rawAtomData.data()[i]) + 512;
            if (atom == m_netWMStateMaxHorzAtom || atom == m_netWMStateMaxVertAtom)
                return true;
        }
    }

    return false;
}

void RoundedWindow::drawWindow(KWin::EffectWindow *w, int mask, const QRegion &region, KWin::WindowPaintData &data)
{
    if (!w->isPaintingEnabled() || ((mask & PAINT_WINDOW_LANCZOS))) {
        return KWin::Effect::drawWindow(w, mask, region, data);
    }

    if (isMaximized(w)) {
        return KWin::Effect::drawWindow(w, mask, region, data);
    }

    if (KWin::effects->hasActiveFullScreenEffect() || w->isFullScreen()) {
        return KWin::Effect::drawWindow(w, mask, region, data);
    }

    if (w->isDesktop()
            || w->isMenu()
            || w->isDock()
            || w->isPopupWindow()
            || w->isPopupMenu()
            #if KWIN_EFFECT_API_VERSION < 233
                 || !hasShadow(data.quads)
            #endif
        ) {
        if (!allowList.contains(w->windowClass()))
            return KWin::Effect::drawWindow(w, mask, region, data);
    }

    // 设置 alpha 通道混合
    if (!w->hasAlpha()) {
        if (setDepthfunc) {
            setDepthfunc(w->parent(), 32);
        }
    }

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    float borderColor[] = { 1.0f, 1.0f, 1.0f, 1.0f };

    auto textureTopLeft = m_texure;
    glActiveTexture(GL_TEXTURE10);
    textureTopLeft->bind();
    glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);
    glActiveTexture(GL_TEXTURE0);

    auto textureTopRight = m_texure;
    glActiveTexture(GL_TEXTURE11);
    textureTopRight->bind();
    glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);
    glActiveTexture(GL_TEXTURE0);

    auto textureBottomLeft = m_texure;
    glActiveTexture(GL_TEXTURE12);
    textureBottomLeft->bind();
    glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);
    glActiveTexture(GL_TEXTURE0);

    auto textureBottomRight = m_texure;
    glActiveTexture(GL_TEXTURE13);
    textureBottomRight->bind();
    glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);
    glActiveTexture(GL_TEXTURE0);

    KWin::GLShader *oldShader = data.shader;
    data.shader = m_shader;
    KWin::ShaderManager::instance()->pushShader(m_shader);

    m_shader->setUniform("topleft", 10);
    m_shader->setUniform("scale", QVector2D(w->width() * 1.0 / textureTopLeft->width(),
                                               w->height() * 1.0 / textureTopLeft->height()));

    m_shader->setUniform("topright", 11);
    m_shader->setUniform("scale1", QVector2D(w->width() * 1.0 / textureTopRight->width(),
                                                w->height() * 1.0 / textureTopRight->height()));

    m_shader->setUniform("bottomleft", 12);
    m_shader->setUniform("scale2", QVector2D(w->width() * 1.0 / textureBottomLeft->width(),
                                                w->height() * 1.0 / textureBottomLeft->height()));

    m_shader->setUniform("bottomright", 13);
    m_shader->setUniform("scale3", QVector2D(w->width() * 1.0 / textureBottomRight->width(),
                                                w->height() * 1.0 / textureBottomRight->height()));

    KWin::Effect::drawWindow(w, mask, region, data);
    KWin::ShaderManager::instance()->popShader();

    data.shader = oldShader;

    glActiveTexture(GL_TEXTURE10);
    textureTopLeft->unbind();
    glActiveTexture(GL_TEXTURE0);

    glActiveTexture(GL_TEXTURE11);
    textureTopRight->unbind();
    glActiveTexture(GL_TEXTURE0);

    glActiveTexture(GL_TEXTURE12);
    textureBottomLeft->unbind();
    glActiveTexture(GL_TEXTURE0);

    glActiveTexture(GL_TEXTURE13);
    textureBottomRight->unbind();
    glActiveTexture(GL_TEXTURE0);

    glDisable(GL_BLEND);
}
