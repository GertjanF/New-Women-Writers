--
-- Copyright 2009 Huygens Instituut for the History of the Netherlands, Den Haag, The Netherlands.
--
-- This file is part of New Women Writers.
--
-- New Women Writers is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- New Women Writers is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with New Women Writers.  If not, see <http://www.gnu.org/licenses/>.
--

CREATE TABLE 'companies' (
  'id' INTEGER PRIMARY KEY NOT NULL,
  'name' TEXT DEFAULT NULL,
  'rating' INTEGER DEFAULT 1
);

CREATE TABLE 'replies' (
  'id' INTEGER PRIMARY KEY NOT NULL, 
  'content' text, 
  'created_at' datetime, 
  'updated_at' datetime, 
  'topic_id' integer,
  'developer_id' integer
);

CREATE TABLE 'topics' (
  'id' INTEGER PRIMARY KEY NOT NULL, 
  'title' varchar(255), 
  'subtitle' varchar(255), 
  'content' text, 
  'created_at' datetime, 
  'updated_at' datetime
);

CREATE TABLE 'developers' (
  'id' INTEGER PRIMARY KEY NOT NULL,
  'name' TEXT DEFAULT NULL,
  'salary' INTEGER DEFAULT 70000,
  'created_at' DATETIME DEFAULT NULL,
  'updated_at' DATETIME DEFAULT NULL
);

CREATE TABLE 'projects' (
  'id' INTEGER PRIMARY KEY NOT NULL,
  'name' TEXT DEFAULT NULL
);

CREATE TABLE 'developers_projects' (
  'developer_id' INTEGER NOT NULL,
  'project_id' INTEGER NOT NULL,
  'joined_on' DATE DEFAULT NULL,
  'access_level' INTEGER DEFAULT 1
);

CREATE TABLE 'mascots' (
  'id' INTEGER PRIMARY KEY NOT NULL, 
  'company_id' INTEGER NOT NULL,
  'name' TEXT DEFAULT NULL
);