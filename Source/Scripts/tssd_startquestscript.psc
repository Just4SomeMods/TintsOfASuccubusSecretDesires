Scriptname tssd_startquestscript extends ObjectReference  

Quest Property tssd_dealwithcurseQuest Auto

Event OnActivate(ObjectReference akActionRef)

    tssd_dealwithcurseQuest.Setstage(10)    

EndEvent