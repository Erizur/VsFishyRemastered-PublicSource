local defaultNotePos = {};
local spin = false;
local arrowMoveY = 14;
local fadearrows = false;
local forcemiddlescroll = false;
local showdadhit = false;

function onCreate()
	
end

--IF YOU HAVE ANY QUESTIONS ABOUT THIS SCRIPT
--
--MSG ME ON DISCORD
--
--@lunarcleint#8859
--
--OR @ ME IN #coding-modding-help
--IN THE MODDIN COMMUNITY DISCORD SERVER
--
--IF YOU WOULD LIKE TO USE MY FUNCTIONS PLEASE CREDIT ME 
--
--MADE BY:
--BBPanzu: (OG Mod Creator)
--Lunarcleint: (Mod Charter)
--
--THANK YOU FOR READING
--                 -lunar

--Stores all the default note postions at song start (for use in for loops)
--                                                    -lunar

-- HEY GUYS so as you see im not the one that made this script credits to lunarcleint for this cool modchart
-- erizur
function onSongStart()
    for i = 0,7 do
        x = getPropertyFromGroup('strumLineNotes', i, 'x')

        y = getPropertyFromGroup('strumLineNotes', i, 'y')

        table.insert(defaultNotePos, {x, y})
    end
end

    --TIMING/NOTE MOVING SHIT--
--                              -lunar
function onUpdate(elapsed)

    songPos = getPropertyFromClass('Conductor', 'songPosition');

    currentBeat = (songPos / 1000) * (bpm / 60)

    --spiny shit at the start
    --                      -lunar
    if spin == true then 
        for i = 0,7 do -- dont use before song started (will be nil) -lunar
            --setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + arrowMoveX * math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + arrowMoveY * math.cos((currentBeat + i*0.25) * math.pi))
        end
    end

    --tbh im not happy with this var but it works
    --                              -lunar

    if fadearrows == true then 
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        end
        if downscroll == true then -- acounts for scrolling - lunar
            fuck = 570
        else
            fuck = 50
        end
        for i = 4,7 do 
            setPropertyFromGroup('strumLineNotes', i, 'x', 412 + ((i - 4) * 112))
            setPropertyFromGroup('strumLineNotes', i, 'y', fuck)
        end
        moveAllStrums(10000,0,0,false,true)
    end

    time = songPos / 1000;

    --showing the strums at the start of the song (please make better timings then me and send them to my discord above xd)
    --                                                                              -lunar
end

function onStepHit() --im so sorry for this function xd -lunar
    stepdev = curStep % 16;
    --makes a section var since there isnt any anywhere else -lunar
    if stepdev == 0 then 
        section = curStep / 16;
    end
    --The camera thing to the BAaaa Baaaa BAAAaaaaa
    --                              -lunar
    if section == 16 or section == 17 or section == 24 or section == 26 or section == 40 or section == 42 then
        if forcemiddlescroll == true then
            deez = 412;
        else
            deez = defaultNotePos[5][1]
        end

        if stepdev == 1 or stepdev == 11 then
            dick = 0;
            if stepdev == 11 then
                cooltimeshit = rangeRandom(0.4,0.5)
            else
                cooltimeshit = rangeRandom(0.35,0.5)
            end

            if section % 4 == 0 then
                if stepdev == 1 then 
                    dick = 15
                else 
                    dick = 0
                end
            else
                if stepdev == 1 then 
                    dick = -15
                else
                    dick = 0
                end
            end
            
            doTweenAngle('turn', 'camHUD', dick, cooltimeshit, 'circOut')
            doTweenAngle('turn1', 'camGame', dick, cooltimeshit, 'circOut')
        end
        if stepdev == 6 then 
            cooltimeshit = rangeRandom(0.3,0.5)
            if section % 4 == 0 then
                doTweenAngle('turn2', 'camHUD', -15, cooltimeshit, 'circOut')
                doTweenAngle('turn3', 'camGame', -15, cooltimeshit, 'circOut')
            else
                doTweenAngle('turn4', 'camHUD', 15, cooltimeshit, 'circOut')
                doTweenAngle('turn5', 'camGame', 15, cooltimeshit, 'circOut')
            end
        end
    end

    --bumpin arrows for the first section
    --                        -lunar
    if section >= 10 and section <= 25 then
        spin = true;
        if stepdev == 4 then 
            bumpArrows(0.2,40,15);
        end
        if stepdev == 12 then
            bumpArrows(0.2,60,20)
        end 
    end

    --zooming cam
    --      -lunar
    if curStep >= 160 and curStep <= 416 or curStep >= 800 and curStep <= 1312 or section >= 88 and section <= 111 then
        if curStep % 4 == 0 then
            doTweenZoom("bop", "camHUD", 1.015, (stepCrochet/1000)/2, "linear")
            doTweenZoom("bop1", "camGame", 1.0015, (stepCrochet/1000)/2, "linear")
        end
    end
    --bumpin for the second section these are used
    --                              -lunar
    if section >= 88 and section <= 111 then
        if stepdev == 5 then 
            bumpArrows(0.2,30,10);
        end
        if stepdev == 12 then 
            bumpArrows(0.2,20,5);
        end
    end
end

--Unused effect (would fade the Strums that the opponent is singing)
--                                      -lunar
function opponentNoteHit(id, direction, noteType, isSustainNote)
    if showdadhit == true then 
	    noteTweenAlpha("cooleffect" .. direction, direction + 4, 0.1, 0.1, "linear")
    end
end

function onTimerCompleted(tag, loops, loopsLeft)

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

function rangeRandom(from, to)
    return from + (math.random() * (to - from))
end

        --CUTSTOM NOTE FUNCTIONS--
--                                  -lunar
function coolresetStrums(time) -- :sunglasses: -lunar
    for i = 4,7 do
        noteTweenX("movementX " .. i, i, defaultNotePos[i + 1][1], time, "linear")
        noteTweenY("movementY " .. i, i, defaultNotePos[i + 1][2], time, "linear")
        noteTweenAngle("movementAngle " .. i, i, 360, time, "linear")
    end
end

function randomNote() -- i get this is shit -lunar
    for i = 4,7 do
        setPropertyFromGroup('strumLineNotes', i, 'x', 
        defaultNotePos[i + 1][1] + math.floor(math.random(-150,150)))

        if downscroll == true then 
            ylowest = 50;
            yhighest = -150;
        else 
            ylowest = -150
            yhighest = 150;
        end

        setPropertyFromGroup('strumLineNotes', i, 'y', 
        defaultNotePos[i + 1][2] + math.floor(math.random(ylowest,yhighest)))
    end
end

function bumpArrows(time, amount, smallamount)
    for i = 4,7 do
        shit = 0;
        if i == 4 then
            shit = -amount
        end
        if i == 5 then
            shit = -smallamount
        end
        if i == 6 then
            shit = smallamount
        end
        if i == 7 then
            shit = amount
        end
        setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x') + shit)
        noteTweenX("movementXbump " .. i, i, getPropertyFromGroup('strumLineNotes', i, 'x') - shit, time, "linear")
    end
end

function fadeStrums(alpha,time,movebf,movedad)
    if time <= 0 then
        if movebf == true then
            for i = 4,7 do 
                setPropertyFromGroup('strumLineNotes', i, 'alpha', alpha)
            end
        end
        if movedad == true then
            for i = 0,3 do
                setPropertyFromGroup('strumLineNotes', i, 'alpha', alpha)
            end
        end
    else
        if movebf == true then
            for i = 4,7 do 
                noteTweenAlpha("movementAlpha " .. i, i, alpha, time, "linear")
            end
        end
        if movedad == true then
            for i = 0,3 do 
                noteTweenAlpha("movementAlpha " .. i, i, alpha, time, "linear")
            end
        end
    end
end

--Goes unsed but thought i would put it in anyway
--                               -lunar
function movebyStrumLine(x,y,time,movebf,movedad) --based on left arrow postion -lunar
    if y == nil then 
        if downscroll == true then -- acounts for scrolling - lunar
            y = 570
        else
            y = 50
        end
    end

    if time <= 0 then
        if movebf == true then
            for i = 4,7 do 
                setPropertyFromGroup('strumLineNotes', i, 'x', x + ((i - 4) * 112))
                setPropertyFromGroup('strumLineNotes', i, 'y', y)
            end
        end
        if movedad == true then
            for i = 0,3 do 
                setPropertyFromGroup('strumLineNotes', i, 'x', x + (i * 112))
                setPropertyFromGroup('strumLineNotes', i, 'y', y)
            end
        end
    else
        if movebf == true then
            for i = 4,7 do 
                noteTweenX("movementX " .. i, i, x + ((i - 4) * 112), time, "linear")
                noteTweenY("movementY " .. i, i, y, time, "linear")
            end
        end
        if movedad == true then
            for i = 0,3 do
                noteTweenX("movementX " .. i, i, x + (i * 112), time, "linear")
                noteTweenY("movementY " .. i, i, y, time, "linear")
            end
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

function moveAllStrums(x,y,time,movebf,movedad) --unused but here anyway -lunar
    if time <= 0 then
        if movebf == true then
            for i = 4,7 do 
                setPropertyFromGroup('strumLineNotes', i, 'x', x)
                setPropertyFromGroup('strumLineNotes', i, 'y', y)
            end
        end
        if movedad == true then
            for i = 0,3 do 
                setPropertyFromGroup('strumLineNotes', i, 'x', x)
                setPropertyFromGroup('strumLineNotes', i, 'y', y)
            end
        end
    else
        if movebf == true then
            for i = 4,7 do 
                noteTweenX("movementX " .. i, i, x, time, "linear")
                noteTweenY("movementY " .. i, i, y, time, "linear")
            end
        end
        if movedad == true then
            for i = 0,3 do 
                noteTweenX("movementX " .. i, i, x, time, "linear")
                noteTweenY("movementY " .. i, i, y, time, "linear")
            end
        end
    end
end
