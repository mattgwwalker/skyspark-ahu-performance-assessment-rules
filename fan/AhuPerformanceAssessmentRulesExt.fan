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


using haystack
using proj

**
** AhuPerformanceAssessmentRules Extension
**
@ExtMeta
{
  name    = "ahuPerformanceAssessmentRules"
  icon24  = `fan://ahuPerformanceAssessmentRulesExt/res/img/SimultaneousCoolAndHeat24.png`
  icon72  = `fan://frescoRes/img/iconMissing72.png`
  depends = Str[,]
}
const class AhuPerformanceAssessmentRulesExt : Ext
{
  @NoDoc new make(Proj proj) : super(proj) {}
}
