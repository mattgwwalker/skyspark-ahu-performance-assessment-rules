#! /usr/bin/env fan
/*
  Copyright 2016 Matthew Walker, Direct Control
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  
  History:
    2016-02-18   Matthew Walker   Creation
    2016-04-22   Matthew Walker   Added GPLv3 license
*/

using build

**
** Build: ahuPerformanceAssessmentRulesExt
**
class Build : BuildPod
{
  new make()
  {
    podName = "ahuPerformanceAssessmentRulesExt"
    summary = "TODO: summary of pod name..."
    version = Version("1.0")
    meta    = [
                "org.name":     "Direct Control",
                //"org.uri":      "http://acme.com/",
                //"proj.name":    "Project Name",
                //"proj.uri":     "http://acme.com/product/",
                "license.name": "Commercial",
              ]
    depends = ["sys 1.0",
               "haystack 2.1",
               "proj 2.1",
	       "hisExt 2.1",
	       "hisKitExt 2.1",
	       "concurrent 1.0",
	       "util 1.0"]
    srcDirs = [`fan/`,
               `test/`]
    resDirs = [`locale/`,
               `lib/`,
	       `res/`,
	       `res/img/`]
    index   =
    [
      "proj.ext": "ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesExt",
      "proj.lib": "ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesLib",
    ]
  }
}
