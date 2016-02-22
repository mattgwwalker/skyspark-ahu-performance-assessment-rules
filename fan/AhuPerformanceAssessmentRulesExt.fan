//
// Copyright (c) 2016, Direct Control
// All Rights Reserved
//
// History:
//   18 Feb 16   Matthew Walker   Creation
//

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
