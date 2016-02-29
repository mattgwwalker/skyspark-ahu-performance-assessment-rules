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
  ** Tests that the record pointed to by ref has an 'ahu' tag.
  ** Returns null on success.
  **
  static Str? testModelHasAhuTag(Ref ref, Proj? proj := null)
  {
    // Read record pointed to by ref
    rec := proj.readById(ref)

    if (!rec.has("ahu")) return "No 'ahu' tag found in "+rec.get("id")

    // No errors found
    return null
  }


  **
  ** Tests that there is a record within proj that has a discharge air
  ** temp with an equipRef that points to ref.
  **
  static Str? testModelHasDischargeAirTemp(Ref ref, Proj? proj := null)
  {
    filter := "discharge and air and temp and sensor and point and equipRef==$ref.toCode"
    grid := proj.readAll(filter)
    size := grid.size()
    if (size <= 0) return "No discharge air temperature was found for '"+ref.toCode()+"'.  There is not at least one match for the filter:\n'$filter'."

    // No errors found
    return null
  }


  **
  ** Tests that there is a record within proj that has a mixed air
  ** temp with an equipRef that points to ref.
  **
  static Str? testModelHasMixedAirTemp(Ref ref, Proj? proj := null)
  {
    filter := "mixed and air and temp and sensor and point and equipRef==$ref.toCode"
    grid := proj.readAll(filter)
    size := grid.size()
    if (size <= 0) return "No mixed air temperature was found for '"+ref.toCode()+"'.  There is not at least one match for the filter:\n'$filter'."

    // No errors found
    return null
  }



  **
  ** Tests that there is a record within proj that has a mixed air
  ** temp with an equipRef that points to ref.
  **
  static Str? testModelHasReturnAirTemp(Ref ref, Proj? proj := null)
  {
    filter := "return".toCode + " and air and temp and sensor and point and equipRef==$ref.toCode"
    grid := proj.readAll(filter)
    size := grid.size()
    if (size <= 0) return "No return air temperature was found for '"+ref.toCode()+"'.  There is not at least one match for the filter:\n'$filter'."

    // No errors found
    return null
  }



  static Str? testModelRule01(Ref ref, Proj? proj := null)
  {
    // Test that the ref provided is indeed an ahu
    result := testModelHasAhuTag(ref, proj)
    if (result!=null) return result

    // Test that there exists a 'discharge air temp' record
    result = testModelHasDischargeAirTemp(ref, proj)
    if (result!=null) return result

    // Test that there exists a 'mixed air temp' record
    result = testModelHasMixedAirTemp(ref, proj)
    if (result!=null) return result

    // Test that there exists a 'return air temp' record
    result = testModelHasReturnAirTemp(ref, proj)
    if (result!=null) return result


    return result
  }

  **
  ** The Fantom method that actually does the model testing for rule 22.
  **
  ** Takes a reference to the ahu record, and the proj on which to
  ** execute the test.
  **
  ** Returns null on success.  On failure a string describing the
  ** first encountered problem is returned.
  **
  static Str? testModelRule22(Ref ref, Proj? proj := null)
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
  ** Test that the model of the AHU is correct for the specified rule.
  ** If no rule is specified, each of the 28 rules is assessed one
  ** after the other (TODO).
  **
  @Axon
  static Str? aparTestModel(Ref? ref, Number? rule := null)
  {
    proj := Context.cur.proj

    if (rule.toInt()==1)  return testModelRule01(ref, proj)
    if (rule.toInt()==22) return testModelRule22(ref, proj)

    return "No tests executed"
  }
}
