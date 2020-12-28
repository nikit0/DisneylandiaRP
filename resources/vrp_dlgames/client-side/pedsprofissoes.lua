local pedlist = {
	{ 2432.78,4802.78,34.82,128.22,0xFCFA9E1E,"A_C_Cow" },
	{ 2440.98,4794.38,34.66,128.22,0xFCFA9E1E,"A_C_Cow" },
	{ 2449.0,4786.67,34.65,128.22,0xFCFA9E1E,"A_C_Cow" },
	{ 2457.28,4778.75,34.52,128.22,0xFCFA9E1E,"A_C_Cow" },
	{ 2464.67,4770.23,34.38,128.22,0xFCFA9E1E,"A_C_Cow" },
	--[[{ -309.77,6272.08,31.5,42.91,0xF161D212,"s_m_m_highsec_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1980.34,3049.59,50.44,151.16,0x61C81C85,"a_f_o_genstreet_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1308.46,315.35,82.0,15.18,0xD5BA52FF,"ig_roccopelosi","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1062.06,-1663.29,4.57,97.97,0x26EF3426,"g_m_y_mexgoon_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 845.08,-901.74,25.26,277.03,0x0F977CEB,"s_m_y_chef_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 453.67,-601.26,28.6,271.75,0xEDA0082D,"ig_jimmyboston","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 903.66,-165.75,74.09,243.27,0xBE204C9B,"ig_joeminuteman","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 354.7,274.19,103.12,257.19,0xCDEF5408,"mp_s_m_armoured_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -841.71,5401.02,34.62,294.99,0x37FACDA6,"ig_money","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 24.49,-1347.31,29.5,271.34,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 2557.25,380.8,108.63,355.54,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1164.71,-322.72,69.21,98.92,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -706.11,-913.66,19.22,92.34,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -46.71,-1757.96,29.43,50.34,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 372.54,326.38,103.57,254.31,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -3242.27,999.97,12.84,354.9,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1727.86,6415.24,35.04,241.92,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 549.1,2671.31,42.16,95.92,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1960.1,3740.04,32.35,300.65,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 2678.1,3279.4,55.25,335.7,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1698.09,4922.92,42.07,328.31,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1820.07,794.18,138.09,131.05,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1392.81,3606.47,34.99,200.07,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -2966.44,390.93,15.05,85.99,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -3038.95,584.55,7.91,16.82,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1134.2,-982.52,46.42,278.98,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1165.87,2710.83,38.16,181.59,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1486.25,-378.0,40.17,132.59,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1221.92,-908.29,12.33,34.77,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 160.56,6641.64,31.72,225.9,0x8B7D3766,"u_m_y_burgerdrug_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1692.2,3760.96,34.71,225.61,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 253.78,-50.57,69.95,65.21,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 842.46,-1035.24,28.2,357.31,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -331.59,6085.03,31.46,222.94,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -662.29,-933.6,21.83,179.34,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1304.08,-394.6,36.7,75.11,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1118.94,2699.81,18.56,220.65,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 2568.04,292.65,108.74,359.32,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -3173.56,1088.33,20.84,246.11,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 22.55,-1105.53,29.8,160.13,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 810.2,-2159.05,29.62,359.45,0x1A021B83,"s_m_m_cntrybar_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1773.4,3322.14,41.45,27.71,0xF06B849D,"s_m_m_autoshop_02","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1083.3,-245.93,37.77,206.79,0x2F8845A3,"ig_barry","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1564.01,-975.12,13.02,234.03,0xEF154C47,"ig_old_man2","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1592.35,-1005.57,13.03,232.04,0x719D27F4,"ig_old_man1a","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 73.98,-1392.81,29.38,267.12,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -708.34,-152.77,37.42,119.8,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -164.54,-301.92,39.74,246.23,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 427.07,-806.19,29.5,91.2,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -823.1,-1072.3,11.33,208.54,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1194.58,-767.5,17.32,212.84,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1449.72,-238.91,49.82,44.85,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 5.79,6511.36,31.88,40.19,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1695.35,4823.03,42.07,97.63,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 127.31,-223.42,54.56,68.28,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 612.99,2761.83,42.09,269.46,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 1196.6,2711.64,38.23,177.03,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -3169.09,1044.05,20.87,64.38,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -1102.51,2711.51,19.11,219.7,0x5B3BD90D,"ig_kerrymcintosh","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -69.88,-1230.79,28.95,230.75,0xE497BBEF,"s_m_y_dealer_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 724.85,-1075.51,22.17,264.49,0x62CC28E2,"s_m_y_armymech_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },]]
	{ 313.91,-1996.1,21.77,48.12,0xE497BBEF,"s_m_y_dealer_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ 93.55,-1948.87,20.76,307.83,0xE497BBEF,"s_m_y_dealer_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -185.76,-1702.52,32.79,315.71,0xE497BBEF,"s_m_y_dealer_01","anim@heists@heist_corona@single_team","single_team_loop_boss" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local localPeds = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))

        for k,v in pairs(pedlist) do
            local distance = GetDistanceBetweenCoords(x,y,z,v[1],v[2],v[3],true)
            if distance <= 10 then
                if localPeds[k] == nil then
                    RequestModel(GetHashKey(v[6]))
                    while not HasModelLoaded(GetHashKey(v[6])) do
                        RequestModel(GetHashKey(v[6]))
                        Citizen.Wait(10)
                    end

                    localPeds[k] = CreatePed(4,v[5],v[1],v[2],v[3]-1,v[4],false,true)
                    SetEntityInvincible(localPeds[k],true)
                    FreezeEntityPosition(localPeds[k],true)
                    SetBlockingOfNonTemporaryEvents(localPeds[k],true)

                    if v[7] ~= nil then
                        RequestAnimDict(v[7])
                        while not HasAnimDictLoaded(v[7]) do
                            RequestAnimDict(v[7])
                            Citizen.Wait(10)
                        end

                        TaskPlayAnim(localPeds[k],v[7],v[8],8.0,0.0,-1,1,0,0,0,0)
                    end
                end
            else
                if localPeds[k] then
                    DeleteEntity(localPeds[k])
                    localPeds[k] = nil
                end
            end
        end
    end
end)