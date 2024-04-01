grammar UseCaseModel;
use_case_model : use_case_model_declaration use_case_model_definition;
use_case_model_declaration : 'Use-Case Model' Colon model_name
                              documentation?;

use_case_model_definition : use_case_model_interruptible_regions? container use_case*;
use_case_model_interruptible_regions : use_case_model_interruptible_region*;
use_case_model_interruptible_region :
'Any use-case can be interrupted by' event_name+ 'event' |
'Use-case' use_case_name+ 'can be interrupted by' event_name+ 'event';

use_case : use_case_declaration use_case_definition;
use_case_declaration : 'Use-Case' Colon use_case_name parent?
                        documentation?
                        preconditions?
                        postconditions?;
parent : '-->' use_case_name;
use_case_definition:   use_case_interruptible_region*
                       container;
documentation : 'Documentation' Colon casual;
preconditions : 'Preconditions' Colon ('-' casual)+;
postconditions : postconditon+;
postconditon : 'Postcondition (' state ')' Colon ('-' casual)+;
use_case_interruptible_region : ('Any flow' | flow_name+) 'can be interrupted by' event_name+ 'event';

container : elem*;
elem : flow | subflow  ;

subflow : subflow_declaration subflow_definition;
subflow_declaration : 'Subflow' subflow_id Colon subflow_name;
subflow_id : Name;

flow_definition : step+ flow_extensions*;

flow : trigger? flow_declaration flow_definition;
flow_declaration : main_flow_declaration | alternative_flow_declaration;
main_flow_declaration : 'Main flow' Colon;
alternative_flow_declaration : 'Flow' flow_id Colon flow_name;
subflow_definition : flow_definition;

trigger : 'Trigger' Colon trigger_type;
trigger_type : event_trigger | actor_trigger;

event_trigger : 'Actor sends' event_name 'event' ('with' ctx_name)?;
actor_trigger :  'Actor wants' casual;

step : Step_Id action;
action : casual | final | internal_loop | conditional |
   goto | actor_choice | reference | gotoCtx | dependency;
casual : Sentence;
final :  final_use_case | final_system;
final_use_case : 'The use-case ends with' state;
final_system : 'The system ends';
internal_loop : casual 'until' condition | casual ('max')? Number 'times';
condition : casual;
conditional :  ('System verifies' | 'System verifies that') condition;
actor_choice : 'Actor chooses' casual;
overriding : Step_Id actor_choice;
goto : 'Goto' reference_to_step;
gotoCtx : 'Goto ctx' ctx_name?;
reference : (reference_to_step action? | reference_to_range action? | reference_to_subflow) ;
reference_to_step : Step_Id;
range : reference_to_step '-' reference_to_step;
reference_to_range : range;
reference_to_subflow : 'subflow' subflow_name;
dependency : include | extend;
include : 'System includes' use_case_name 'use-case';
extend : 'Extension point' Colon condition 'The flow is extended with' use_case_name 'use-case';

flow_extensions : flow_interruptible_region | loop_region;
flow_interruptible_region : 'Steps' range 'can be interrupted by' event_name+ 'event' ('with' ctx_name)?;
loop_region : 'Steps' range 'can be repeated until' condition | 'Steps' range 'can be repeated max' Number 'times';

ctx_name : Name;
flow_id : Name;
flow_name : Name;
model_name : Name ;
subflow_name : Name ;
use_case_name : Name ;
event_name : Name ;
state : Name ;

Name : [a-zA-Z]+[_a-zA-Z0-9'/]*;
Colon : ':' ;
WS : [ \t\r\n]+ -> skip ;
Semicolon : ';' ;
Sentence : '"'[()_a-zA-Z0-9 ?'’,/.-]*'"';
Number : [0-9]+;
Dot : '.';
Word : [A-Za-z][A-Za-z]*;
Step_Id : [A-Z]*[0-9]+ Dot ;