ScriptName tssd_utils hidden

float Function Max(float a, float b) Global
    if a > b 
        return a
    endif
    return b
EndFunction

float Function Min(float a, float b) Global
    if b > a 
        return a
    endif
    return b
EndFunction


Bool Function SafeProcess() Global
    If (!Utility.IsInMenuMode()) && (!UI.IsMenuOpen("Dialogue Menu")) && (!UI.IsMenuOpen("Console")) && (!UI.IsMenuOpen("Crafting Menu")) && (!UI.IsMenuOpen("MessageBoxMenu")) && (!UI.IsMenuOpen("ContainerMenu")) && (!UI.IsMenuOpen("InventoryMenu")) && (!UI.IsMenuOpen("BarterMenu")) && (!UI.IsTextInputEnabled())
    Return True
    Else
    Return False
    EndIf
EndFunction

float[] Function CopyArray(float[] arr1) Global
    float[] arr2 = Utility.CreateFloatArray(arr1.Length)
    int index = 0
    while index < arr2.length
        arr2[index] = arr1[index]
        index+=1
    EndWhile
    return arr2
EndFunction


String Function GenerateFullPath(String filename) Global
    Return "Data/Tssd/" + filename + ".json"
EndFunction