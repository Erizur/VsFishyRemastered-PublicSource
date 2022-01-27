local defaultNotePos = {};
local spin = false;
local arrowMoveY = 14;
local fadearrows = false;
local forcemiddlescroll = false;
local showdadhit = false;
local hitCam = false
local modifierThing = 0.25

function onCreate()
	
end


function onSongStart()
    for i = 0,7 do
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
        y = getPropertyFromGroup('strumLineNotes', i, 'y')

        table.insert(defaultNotePos, {x, y})

        spin = true;
    end
end


local crazy = false

function onUpdate(elapsed)

    songPos = getPropertyFromClass('Conductor', 'songPosition');

    currentBeat = (songPos / 1000) * (bpm / 60)

    if spin == true then 
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + arrowMoveY * math.cos((currentBeat + i* modifierThing) * math.pi))
        end
    end

    time = songPos / 1000;                                                                        
end

function onStepHit() --im so sorry for this function xd -lunar

    stepdev = curStep % 16;

    if stepdev == 0 then 
        section = curStep / 16;
    end

    if hitCam then
        if curStep % 4 == 0 then            
            doTweenZoom("bop", "camHUD", 1.0090, (stepCrochet/1000) / 0.5, "linear");
            doTweenZoom("bop1", "camGame", 1.01, (stepCrochet/1000) / 0.5, "linear");
            cameraShake("camGame", 0.007, 0.1)
        end
    end


    if curStep == 384 then
        hitCam = true;
    end
    if curStep == 1152 then
        hitCam = false;
    end
    if curStep == 1392 then
        cameraShake("camGame", 0.05, 0.6)
    end
    if curStep == 1408 then
        hitCam = true
    end
    if curStep == 1920 then
        hitCam = false;
    end
end


function onTweenCompleted(tag)
    --Things for tween ending or whatever
    --                      -lunar
    if showdadhit == true then
        for i = 0,3 do 
            deez = "cooleffect" .. i;
            direction = i;
            if tag == deez then 
                noteTweenAlpha("cooleffectend" .. direction, direction + 4, 1, 0.1, "linear")
            end
        end
    end
    if tag == "bop" then 
        doTweenZoom("bopback", "camHUD", 1, (stepCrochet/1000)/2, "linear")
        doTweenZoom("bop1back", "camGame", 1, (stepCrochet/1000)/2, "linear")
    end
    for i = 4,7 do 
        deez = "movementXbump " .. i;
        if tag == deez then
            resetStrums();
        end
    end
    for i = 4,7 do 
        deez = "movementAngle " .. i;
        if tag == deez then 
            resetStrums();
        end
    end
end

function resetStrums()
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1])
        setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2])
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
        setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
    end
end 