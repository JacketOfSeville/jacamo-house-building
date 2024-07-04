// Código comum para a parte organizacional do sistema

task_roles("SitePreparation",  [site_prep_contractor]).
task_roles("Floors",           [bricklayer]).
task_roles("Walls",            [bricklayer]).
task_roles("Roof",             [roofer]).
task_roles("WindowsDoors",     [window_fitter, door_fitter]).
task_roles("Plumbing",         [plumber]).
task_roles("ElectricalSystem", [electrician]).
task_roles("Painting",         [painter]).

+!contract(Task,GroupName)
    : task_roles(Task,Roles)
   <- !in_ora4mas;
      !create_auction_artifact(Task, 2000); // create auction artifact for the task
      lookupArtifact("auction_for_" + Task, AuctionId);
      for ( .member( Role, Roles) ) {
         adoptRole(Role)[artifact_id(AuctionId)];
         focus(AuctionId);
         !bid(AuctionId); // bid on the auction
      }.

-!contract(Service,GroupName)[error(E),error_msg(Msg),code(Cmd),code_src(Src),code_line(Line)]
   <- .print("Não conseguiu assinar o contrato de ",Service,"/",GroupName,": ",Msg," (",E,"). comando: ",Cmd, " no ",Src,":", Line).


+!in_ora4mas : in_ora4mas.
+!in_ora4mas : .intend(in_ora4mas)
   <- .wait({+in_ora4mas},100,_);
      !in_ora4mas.
@[atomic]
+!in_ora4mas
   <- joinWorkspace("ora4mas",_);
      +in_ora4mas.

{ include("$jacamo/templates/common-moise.asl") }
{ include("$moise/asl/org-obedient.asl") }