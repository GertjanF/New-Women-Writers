@REM
@REM Copyright 2009 Huygens Instituut for the History of the Netherlands, Den Haag, The Netherlands.
@REM
@REM This file is part of New Women Writers.
@REM
@REM New Women Writers is free software: you can redistribute it and/or modify
@REM it under the terms of the GNU General Public License as published by
@REM the Free Software Foundation, either version 3 of the License, or
@REM (at your option) any later version.
@REM
@REM New Women Writers is distributed in the hope that it will be useful,
@REM but WITHOUT ANY WARRANTY; without even the implied warranty of
@REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@REM GNU General Public License for more details.
@REM
@REM You should have received a copy of the GNU General Public License
@REM along with New Women Writers.  If not, see <http://www.gnu.org/licenses/>.
@REM

@echo off
ruby script/server -blocalhost -edevelopment

rem Next line to start the mongrel service
rem mongrel_rails service::install -Nneww -p3000 -a192.168.1.2 -cC:\railswork\myneww

rem Next line (in directory of RoR app!) to start in production environment, output to terminal
rem mongrel_rails -p3000 -eproduction

rem Next line to start production server deamonized
rem mongrel_rails -p3000 -eproduction &
rem Kill with kill -9 #PID
rem Used ef -ps to look for the #PID of the mongrel server process

