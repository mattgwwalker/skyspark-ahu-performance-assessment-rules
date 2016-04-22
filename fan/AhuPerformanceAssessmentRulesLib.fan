
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
using hisExt


**
** Axon functions for ahuPerformanceAssessmentRules
**
const class AhuPerformanceAssessmentRulesLib
{
  // Returns null on success
  static Str? testModel(Ref ref, Proj? proj := null)
  {
    if (proj==null) proj = Context.cur.proj

    // Read record pointed to by ref
    rec := proj.readById(ref)

    // Check that there is at least one cool point with an equipRef that points
    // to the ref
    filter := "cool and point and equipRef=="+ref.toCode()+" and his and tz and kind"
    grid := proj.readAll(filter)
    size := grid.size()
    if (size <= 0) return "The equipment's 'cool' points aren't correctly configured.  There is not at least one match for the filter '$filter'."

    // Check that there is exactly one heat point with an equipRef that points
    // to the ref
    filter = "heat and point and equipRef=="+ref.toCode()+" and his and tz and kind"
    grid = proj.readAll(filter)
    size = grid.size()
    if (size <= 0) return "The equipment's 'heat' points aren't correctly configured.  There is not at least one match for the filter '$filter'."

    // We've passed all the tests
    return null
  }


  **
  ** Provides model testing from Axon
  **
  @Axon
  static Str? simultaneousCoolAndHeatTestModel(Ref? ref)
  {
    proj := Context.cur.proj

    return testModel(ref, proj)
  }
}
