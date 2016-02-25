//
// Copyright (c) 2016, Direct Control
// All Rights Reserved
//
// History:
//   18 Feb 16   Matthew Walker   Creation
//

using haystack
using proj
using hisExt


**
** Axon functions for ahuPerformanceAssessmentRules
**
const class AhuPerformanceAssessmentRulesLib
{
  **
  ** The Fantom method that actually does the model testing.
  **
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
