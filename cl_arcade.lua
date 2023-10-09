local QBCore = exports['qb-core']:GetCoreObject()
MenuCore = 'ox' -- Use qb or ox
TargetCore = 'ox' -- Use qb or ox

local arcades = {
    'prop_arcade_01',
    'ch_prop_arcade_degenatron_01a',
    'ch_prop_arcade_monkey_01a',
    'ch_prop_arcade_penetrator_01a',
    'ch_prop_arcade_space_01a',
    'ch_prop_arcade_invade_01a',
    'ch_prop_arcade_street_01a',
    -- 'ch_prop_arcade_street_01a_off', -- Disabled by default because this arcade is off.
    'ch_prop_arcade_street_01b',
    -- 'ch_prop_arcade_street_01b_off', -- Disabled by default because this arcade is off.
    'ch_prop_arcade_street_01c',
    -- 'ch_prop_arcade_street_01c_off', -- Disabled by default because this arcade is off.
    'ch_prop_arcade_street_01d',
    -- 'ch_prop_arcade_street_01d_off', -- Disabled by default because this arcade is off.
    'ch_prop_arcade_street_02b',
    'ch_prop_arcade_wizard_01a',
    'sum_prop_arcade_qub3d_01a',
}

if TargetCore == 'qb' then
    exports['qb-target']:AddTargetModel(arcades, {
        options = {
            {
                event = 'arcade:menu',
                icon = 'fas fa-gamepad',
                label = 'Arcade',
            },
        },
        distance = 1.0,
    })
elseif TargetCore == 'ox' then
    exports.ox_target:addModel(arcades, {
        {
            name = 'Arcade',
            label = 'Arcade',
            icon = 'fas fa-gamepad',
            onSelect = function()
                TriggerEvent('arcade:menu')
            end,
        },
    })
end

RegisterNetEvent('arcade:menu', function()
    if MenuCore == 'qb' then
        local arcade = {
            {
                header = 'Arcade',
                isMenuHeader = true
            },
            {
                header = 'Thermite (€250)',
                icon = 'fas fa-dice-d6',
                txt = 'Can you remember all the blocks?',
                params = {
                    event = 'arcade:startGame',
                    args = {game = 'thermite', price = 250}
                }
            },
            {
                header = 'Numbermaze (€300)',
                icon = 'fas fa-puzzle-piece',
                txt = 'Can you go from point A to point B with the numbers?',
                params = {
                    event = 'arcade:startGame',
                    args = {game = 'numbermaze', price = 300}
                }
            },
            {
                header = 'VAR (€350)',
                icon = 'fas fa-hashtag',
                txt = 'Can you remember the correct order?',
                params = {
                    event = 'arcade:startGame',
                    args = {game = 'var', price = 350}
                }
            },
            {
                header = 'Scrambler',
                icon = 'fas fa-magnifying-glass',
                txt = 'Can you find the right numbers and characters?',
                params = {
                    event = 'arcade:startGame',
                    args = {game = 'scrambler', price = 400}
                }
            },
        }
        exports['qb-menu']:openMenu(arcade)
    elseif MenuCore == 'ox' then
        lib.registerContext({
            id = 'arcade',
            title = 'Arcade',
            options = {
                {
                    title = 'Thermite (€250)',
                    description = 'Can you remember all the blocks?',
                    icon = 'dice-d6',
                    disabled = false,
                    event = 'arcade:startGame',
                    args = {game = 'thermite', price = 250},
                },
                {
                    title = 'Numbermaze (€300)',
                    description = 'Can you go from point A to point B with the numbers?',
                    icon = 'puzzle-piece',
                    disabled = false,
                    event = 'arcade:startGame',
                    args = {game = 'numbermaze', price = 300},
                },
                {
                    title = 'VAR (€350)',
                    description = 'Can you remember the correct order?',
                    icon = 'hashtag',
                    disabled = false,
                    event = 'arcade:startGame',
                    args = {game = 'var', price = 350},
                },
                {
                    title = 'Scrambler (€400)',
                    description = 'Can you find the right numbers and characters?',
                    icon = 'magnifying-glass',
                    disabled = false,
                    event = 'arcade:startGame',
                    args = {game = 'scrambler', price = 400},
                },
            }
        })
        lib.showContext('arcade')
    end
end)

RegisterNetEvent('arcade:startGame', function(data)
    QBCore.Functions.TriggerCallback('arcade:playGame', function(result)
        if result then
            if data.game == 'thermite' then
                exports['ps-ui']:Thermite(function(success)
                    if success then
                        QBCore.Functions.Notify('You have finished the minigame!', 'success')
                    else
                        QBCore.Functions.Notify('You failed the minigame, please try again!', 'error')
                    end
                 end, 10, 5, 3) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
            elseif data.game == 'numbermaze' then
                exports['ps-ui']:Maze(function(success)
                    if success then
                        QBCore.Functions.Notify('You have finished the minigame!', 'success')
                    else
                        QBCore.Functions.Notify('You failed the minigame, please try again!', 'error')
                    end
                end, 20) -- Hack Time Limit
            elseif data.game == 'scrambler' then
                local types = {'alphabet', 'numeric', 'alphanumeric', 'greek', 'braille', 'runes'}
                local currentType = types[math.random(1, #types)]
                exports['ps-ui']:Scrambler(function(success)
                    if success then
                        QBCore.Functions.Notify('You have finished the minigame!', 'success')
                    else
                        QBCore.Functions.Notify('You failed the minigame, please try again!', 'error')
                    end
                end, currentType, math.random(20, 50), 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            elseif data.game == 'var' then
                exports['ps-ui']:VarHack(function(success)
                    if success then
                        QBCore.Functions.Notify('You have finished the minigame!', 'success')
                    else
                        QBCore.Functions.Notify('You failed the minigame, please try again!', 'error')
                    end
                 end, math.random(3, 8), math.random(3, 12)) -- Number of Blocks, Time (seconds)
            end
        else
            QBCore.Functions.Notify('You don\'t have enough cash!', 'error')
        end
    end, data.price)
end)
