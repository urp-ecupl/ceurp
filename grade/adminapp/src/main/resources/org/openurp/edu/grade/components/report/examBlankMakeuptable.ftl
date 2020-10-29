[#ftl]
[#include "reportHeader.ftl"/]
[#include "/template/macros.ftl"/]
[#assign perRecordOfPage = 50/]
[#include "examBlankMacros.ftl"/]
[#include "reportStyle.ftl"/]
[@reportStyle/]
[@b.toolbar title="教学班补缓签到表打印"]
   bar.addPrint();
   bar.addClose();
[/@]
[#list clazzes as clazz]
    [#assign courseGrades = courseGradeMap.get(clazz)/]
    [#assign examTakers = examTakerMap.get(clazz)/]
    [#assign courseGradeState = stateMap.get(clazz)/]

    [#assign squadCourseTakers={}/]
    [#assign retakeCourseTakers=[]/]
    [#assign squadMap={}/]

    [#assign allCourseTakers = courseTakerMap.get(clazz)?sort_by(["std","code"])/]
    [#list allCourseTakers as ct]
      [#if ct.takeType.id ==3]
        [#assign retakeCourseTakers=retakeCourseTakers+[ct]/]
      [#else]
        [#if !(squadCourseTakers[ct.std.squad.name])??]
          [#assign squadMap = squadMap+ {ct.std.squad.name:ct.std.squad}/]
          [#assign squadCourseTakers = squadCourseTakers+ {ct.std.squad.name:[]}/]
        [/#if]
        [#assign squadCourseTakers = squadCourseTakers + {ct.std.squad.name: squadCourseTakers[ct.std.squad.name]+[ct]} /]
      [/#if]
    [/#list]

    [#assign squads =squadCourseTakers?keys/]
    [#list clazz.enrollment.courseTakers as ct]
      [#if ct.takeType.id !=3 && !squads?seq_contains(ct.std.squad.name)]
        [#assign squads = squads + [ct.std.squad.name]/]
        [#assign squadCourseTakers = squadCourseTakers+ {ct.std.squad.name:[]}/]
      [/#if]
    [/#list]

    [#assign squads = squads?sort/]
    [#list squads as squad]
       [#assign squadCourseTakers=squadCourseTakers+{squad:squadCourseTakers[squad]?sort_by(["std","user","code"])}/]
    [/#list]
    [#assign squadCourseTakers=squadCourseTakers+{squads?last:(squadCourseTakers[squads?last]+retakeCourseTakers?sort_by(["std","user","code"]))}/]
    [#list squads as squad]
        [#assign courseTakers=squadCourseTakers[squad]/]
        [#if courseTakers?size==0][#continue/][/#if]
        [#assign recordIndex = 0/]
        [#assign pageSize = ((courseTakers?size / perRecordOfPage)?int * perRecordOfPage == courseTakers?size)?string(courseTakers?size / perRecordOfPage, courseTakers?size / perRecordOfPage + 1)?number/]
        [#list (pageSize == 0)?string(0, 1)?number..pageSize as pageIndex]

        [@makeupReportHead clazz squadMap[squad]/]
        <table align="center" class="reportBody" width="100%">
           [@makeupColumnTitle/]
           [#list 0..(perRecordOfPage / 2 - 1) as onePageRecordIndex]
           <tr>
            [@displayMakeupTake clazz,courseTakers, recordIndex,true/]
            [@displayMakeupTake clazz,courseTakers, recordIndex + perRecordOfPage / 2 ,false/]
            [#assign recordIndex = recordIndex + 1/]
           </tr>
           [/#list]
           [#assign recordIndex = perRecordOfPage * pageIndex/]
        </table>
        [@makeupReportFoot clazz/]
            [#if (pageIndex + 1 < pageSize)]
        <div style="PAGE-BREAK-AFTER: always;"></div>
            [/#if]
        [/#list]
        [#if squad_has_next]
        <div style="PAGE-BREAK-AFTER: always;"></div>
        [/#if]
    [/#list]
    [#if clazz_has_next]
    <div style="PAGE-BREAK-AFTER: always"></div>
    [/#if]
[/#list]
[@b.foot/]
