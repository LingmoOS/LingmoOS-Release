/*
 * Copyright (C) 2020 Reven Martin
 * Copyright (C) 2020 KeePassXC Team <team@keepassxc.org>
 * Copyright (C) 2019 Andrew Richards
 *
 * Derived from Phantomstyle and relicensed under the GPLv2 or v3.
 * https://github.com/randrew/phantomstyle
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 or (at your option)
 * version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef BASESTYLE_H
#define BASESTYLE_H

#include <QCommonStyle>

class BaseStylePrivate;
class ShadowHelper;
class BlurHelper;
class BaseStyle : public QCommonStyle
{
    Q_OBJECT

public:
    BaseStyle();
    ~BaseStyle() override;

    enum PhantomPrimitiveElement
    {
        Phantom_PE_IndicatorTabNew = PE_CustomBase + 1,
        Phantom_PE_ScrollBarSliderVertical,
        Phantom_PE_WindowFrameColor,
    };

    static QPalette lightModePalette();
    static QPalette darkModePalette();
    QPalette standardPalette() const override;
    void drawPrimitive(PrimitiveElement elem,
                       const QStyleOption* option,
                       QPainter* painter,
                       const QWidget* widget = nullptr) const override;
    void
    drawControl(ControlElement ce, const QStyleOption* option, QPainter* painter, const QWidget* widget) const override;
    int pixelMetric(PixelMetric metric,
                    const QStyleOption* option = nullptr,
                    const QWidget* widget = nullptr) const override;
    void drawComplexControl(ComplexControl control,
                            const QStyleOptionComplex* option,
                            QPainter* painter,
                            const QWidget* widget) const override;
    QRect subElementRect(SubElement r, const QStyleOption* opt, const QWidget* widget = nullptr) const override;
    QSize sizeFromContents(ContentsType type,
                           const QStyleOption* option,
                           const QSize& size,
                           const QWidget* widget) const override;
    SubControl hitTestComplexControl(ComplexControl cc,
                                     const QStyleOptionComplex* opt,
                                     const QPoint& pt,
                                     const QWidget* w = nullptr) const override;
    QRect subControlRect(ComplexControl cc,
                         const QStyleOptionComplex* opt,
                         SubControl sc,
                         const QWidget* widget) const override;
    QPixmap generatedIconPixmap(QIcon::Mode iconMode, const QPixmap& pixmap, const QStyleOption* opt) const override;
    int styleHint(StyleHint hint,
                  const QStyleOption* option = nullptr,
                  const QWidget* widget = nullptr,
                  QStyleHintReturn* returnData = nullptr) const override;
    QRect itemPixmapRect(const QRect& r, int flags, const QPixmap& pixmap) const override;
    void drawItemPixmap(QPainter* painter, const QRect& rect, int alignment, const QPixmap& pixmap) const override;
    void drawItemText(QPainter* painter,
                      const QRect& rect,
                      int flags,
                      const QPalette& pal,
                      bool enabled,
                      const QString& text,
                      QPalette::ColorRole textRole = QPalette::NoRole) const override;

    using QCommonStyle::polish;
    void polish(QApplication* app) override;
    void unpolish(QApplication* app) override;
    void polish(QWidget *widget) override;
    void unpolish(QWidget *widget) override;

    bool isDarkMode() const;

protected:
    /**
     * @return Paths to application stylesheets
     */
    virtual QString getAppStyleSheet() const
    {
        return {};
    }

    BaseStylePrivate* d;

private:
    ShadowHelper *m_shadowHelper;
    BlurHelper *m_blurHelper;
};

#endif
