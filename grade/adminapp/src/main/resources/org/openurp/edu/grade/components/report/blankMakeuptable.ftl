[#ftl]
[#if Parameters['exam']?? && Parameters['exam']=='1']
  [#include "examBlankMakeuptable.ftl"/]
[#else]
  [#include "blankMakeuptable1.ftl"/]
[/#if]
