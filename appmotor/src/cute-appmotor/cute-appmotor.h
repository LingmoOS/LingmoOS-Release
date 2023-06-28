/***************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (directui@nokia.com)
**
** This file is part of applauncherd
**
** If you have questions regarding the use of this file, please contact
** Nokia at directui@nokia.com.
**
** This library is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation
** and appearing in the file LICENSE.LGPL included in the packaging
** of this file.
**
****************************************************************************/

#ifndef CUTE_APPMOTOR_H
#define CUTE_APPMOTOR_H

#include "booster.h"

/*!
 * \class CuteBooster.
 * \brief Qt-specific version of the Booster.
 */
class CuteBooster : public Booster
{
public:

    //! Constructor.
    CuteBooster() {};

    //! Destructor.
    virtual ~CuteBooster() {};

    //! \reimp
    virtual const string & boosterType() const;

    virtual void initialize(int initialArgc, char ** initialArgv, int boosterLauncherSocket,
                            int socketFd, SingleInstance * singleInstance,
                            bool bootMode) override;

protected:

    //! \reimp
    virtual bool preload();

    virtual int launchProcess();

private:

    //! Disable copy-constructor
    CuteBooster(const CuteBooster & r);

    //! Disable assignment operator
    CuteBooster & operator= (const CuteBooster & r);

    static const string m_boosterType;
};

#endif //QTBOOSTER_H