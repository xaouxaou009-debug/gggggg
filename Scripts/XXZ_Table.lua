local Table = GameMain:GetMod("XXZ_xiuxianzhuanluatable")




local ShuXingList =
{
{SX="NpcFight_ShieldResistanceToJin",SXV = 0.005 ,SXP = 0 , SXname = "金属性伤害减免"}, 
{SX="NpcFight_ShieldResistanceToMu",SXV = 0.005 ,SXP = 0 , SXname = "木属性伤害减免"}, 
{SX="NpcFight_ShieldResistanceToShui",SXV = 0.005 ,SXP = 0 , SXname = "水属性伤害减免"},
{SX="NpcFight_ShieldResistanceToHuo",SXV = 0.005 ,SXP = 0 , SXname = "火属性伤害减免"},
{SX="NpcFight_ShieldResistanceToTu",SXV = 0.005 ,SXP = 0 , SXname = "土属性伤害减免"}, 
{SX="NpcFight_BaseHitChance",SXV = 0 ,SXP = 0.01 , SXname = "战斗命中"}, 
{SX="NpcFight_BaseDodgeChance",SXV = 0 ,SXP = 0.01 , SXname = "战斗闪避"}, 
{SX="NpcFight_FabaoLingRecoverK",SXV = 0.01 ,SXP = 0 , SXname = "法宝回灵倍率"},
{SX="NpcFight_FabaoLingRecoverAddP",SXV = 0.01 ,SXP = 0 , SXname = "法宝灵气恢复速度"},
{SX="NpcFight_FabaoFlySpeedAddP",SXV = 0 ,SXP = 0.01 , SXname = "法宝飞行速度"},
{SX="NpcFight_FabaoMaxLingAddP",SXV = 0 ,SXP = 0.05 , SXname = "法宝灵气最大值"},
{SX="NpcFight_FabaoRepelDistanceAddV",SXV = 0.05 ,SXP = 0 , SXname = "法宝击退距离"},
{SX="NpcFight_FabaoTurnSpeedAddP",SXV = 0.05 ,SXP = 0 , SXname = "法宝转向速度加成"},
{SX="NpcFight_FabaoRepelResistanceAddV",SXV = 0.05 ,SXP = 0 , SXname = "法宝击退抗性"},
{SX="NpcFight_FabaoTrailingLengthAddP",SXV = 0.05,SXP = 0 , SXname = "法宝拖尾长度"},
{SX="NpcFight_FabaoPowerAddP",SXV = 0 ,SXP = 0.07 , SXname = "法宝伤害"},
{SX="NpcFight_ShieldConversionRate",SXV = 0.05 ,SXP = 0 , SXname = "护盾强度加值"},
{SX="NpcFight_ShieldConversionRateAddP",SXV = 0.05 ,SXP = 0 , SXname = "护盾强度加成"},
{SX="NpcFight_SpellLingCostAddP",SXV = 0 ,SXP = -0.03 , SXname = "术法灵气消耗"},
{SX="NpcFight_SpellCastTimeAddP",SXV = 0 ,SXP = -0.008 , SXname = "术法吟唱时间加成"},
{SX="NpcFight_SpellPowerAddP",SXV = 0 ,SXP = 0.07 , SXname = "术法伤害加成"},
{SX="NpcFight_SpellCoolDownAddP",SXV = 0 ,SXP = -0.003 , SXname = "术法冷却时间"},
{SX="GlobalEfficiency",SXV = 0 ,SXP = 0.05 , SXname = "全局工作速度"},
{SX="TreatSpeed",SXV = 0 ,SXP = 0.05 , SXname = "治疗速度"},
{SX="TreatSuccessChance",SXV = 0 ,SXP = 0.05 , SXname = "治疗成功率"},
{SX="CookingSpeed",SXV = 0 ,SXP = 0.05 , SXname = "烹饪速度"},
{SX="CookingSuccessChance",SXV = 0 ,SXP = 0.05 , SXname = "烹饪成功率"},
{SX="ButcherSpeed",SXV = 0 ,SXP = 0.05 , SXname = "屠宰速度"},
{SX="ButcherYieldEfficiency",SXV = 0 ,SXP = 0.05 , SXname = "屠宰产量"},
{SX="PlantHarvestYieldEfficiency",SXV = 0 ,SXP = 0.05 , SXname = "收获产量"},
{SX="MiningYieldEfficiency",SXV = 0 ,SXP = 0.05 , SXname = "采掘产量"},
{SX="MadeQualityAddValue",SXV = 0.02 ,SXP = 0 , SXname = "制作品质加值"},
{SX="TameSuccessChance",SXV = 0 ,SXP = 0.05 , SXname = "驯服野兽成功率"},
{SX="BaseWorkSpeed",SXV = 0.2 ,SXP = 0 , SXname = "基础工作速度"},
{SX="BaseEmotionAddV",SXV = 1.5 ,SXP = 0 , SXname = "心情基础值"},
{SX="MaxAge",SXV = 2.2 ,SXP = 0 , SXname = "寿元"},
{SX="AgeCostSpeed",SXV = 0 ,SXP = -0.05 , SXname = "寿元流逝速度"},
{SX="VisionRadius",SXV = 0 ,SXP = 0.05 , SXname = "感知范围"},
{SX="MoveSpeed",SXV = 0 ,SXP = 0.05 , SXname = "移动速度"},
{SX="ComfyTMin",SXV = 0 ,SXP = -0.05 , SXname = "最低舒适温度"},
{SX="ComfyTMax",SXV = 0 ,SXP = 0.07 , SXname = "最高舒适温度"},
{SX="ToleranceTMin",SXV = 0 ,SXP = -0.05 , SXname = "最低极限温度"},
{SX="ToleranceTMax",SXV = 0 ,SXP = 0.07 , SXname = "最高极限温度"},
{SX="RecoveryPower",SXV = 0 ,SXP = 0.04 , SXname = "自然恢复力"},
{SX="PainTolerance",SXV = 0 ,SXP = 0.05 , SXname = "疼痛极限"},
{SX="IntelligenceSkillEXPConstant",SXV = 0 ,SXP = 0.1 , SXname = "学习速度"},
{SX="NightmareHappenPercent",SXV = 0 ,SXP = -0.05 , SXname = "噩梦发生几率"},
{SX="NiceDreamHappenPercent",SXV = 0 ,SXP = 0.05 , SXname = "美梦发生几率"},
{SX="FatigueConsumeConstant",SXV = 0 ,SXP = -0.05 , SXname = "精力消耗速度"},
{SX="FatigueRecoveryConstant",SXV = 0 ,SXP = 0.05 , SXname = "精力补充加成"},
{SX="NutritionConsumeConstant",SXV = 0 ,SXP = -0.05 , SXname = "食物消耗速度"},
{SX="NutritionRecoveryConstant",SXV = 0 ,SXP = 0.05 , SXname = "食物补充加成"},
{SX="WaterConsumeConstant",SXV = 0 ,SXP = -0.05 , SXname = "饮水消耗速度"},
{SX="WaterRecoveryConstant",SXV = 0 ,SXP = 0.05 , SXname = "饮水补充加成"},
{SX="HappyConsumeConstant",SXV = 0 ,SXP = -0.05 , SXname = "娱乐消耗速度"},
{SX="HappyRecoveryConstant",SXV = 0 ,SXP = 0.05 , SXname = "娱乐补充加成"},
{SX="PracticeFoodConsumeConstant",SXV = 0 ,SXP = -0.03 , SXname = "精元消耗速度"},
{SX="PracticeFoodRecoveryConstant",SXV = 0 ,SXP = 0.03 , SXname = "精元补充加成"},
{SX="MagicDamageRecoveryPowerAddV",SXV = 0.05 ,SXP = 0 , SXname = "内门伤自然恢复力"},
{SX="PotentialOfBasepracticeAddValue",SXV = 0.05 ,SXP = 0 , SXname = "潜力加值"},
{SX="BasepracticeSpeedCoefficient",SXV = 0.05 ,SXP = 0 , SXname = "筑基速度加成"},
{SX="MaxAccumulativeLingAddV",SXV = 0.02 ,SXP = 0 , SXname = "鼎炉之限加值"},
{SX="DeepPracticeSpeedSpecialCoefficient",SXV = 0.2 ,SXP = 0 , SXname = "修炼速度加成"},
{SX="MindStateBaseValue",SXV = 0.85 ,SXP = 0 , SXname = "心境的基础值"},
{SX="GodPenaltyAddV",SXV = -0.5 ,SXP = 0 , SXname = "天谴加值"},
{SX="SpeedOfMindStateCoefficient",SXV = 0 ,SXP = 0.02 , SXname = "心境稳定程度"},
{SX="InspirationCoefficient",SXV = 0 ,SXP = 0.2 , SXname = "领悟悟性倍率"},
{SX="LingAbsorbSpeed",SXV = 0 ,SXP = 0.03 , SXname = "灵气吸收速度加成"},
{SX="NpcLingMaxValue",SXV = 0 ,SXP = 0.05 , SXname = "灵气最大值"},
{SX="FabaoMake_SpeedAddV",SXV = 0.02 ,SXP = 0 , SXname = "法宝炼制速度加值"},
{SX="FabaoMake_SuccessRateAddV",SXV = 0.05 ,SXP = 0 , SXname = "法宝炼制成功率加值"},
{SX="FabaoMake_LingInheritRateAddV",SXV = 0.03 ,SXP = 0 , SXname = "法宝炼制品阶加成"},
{SX="FabaoMake_QualityAddV",SXV = 0.02 ,SXP = 0 , SXname = "法宝炼制品质加值"},
{SX="FabaoMake_TwelveRateChance",SXV = 0.01 ,SXP = 0 , SXname = "神器炼成基础几率"},
{SX="DanMake_Speed",SXV = 0.06 ,SXP = 0 , SXname = "丹药炼制速度"},
{SX="DanMake_SpeedAddV",SXV = 0.06 ,SXP = 0 , SXname = "丹药炼制速度加值"},
{SX="DanMake_SuccessRate",SXV = 0.02 ,SXP = 0 , SXname = "炼丹技能炼制成功率"},
{SX="DanMake_SuccessRateAddV",SXV = 0.02 ,SXP = 0 , SXname = "丹药炼制成功率加值"},
{SX="DanMake_Yield",SXV = 0.05 ,SXP = 0 , SXname = "炼丹技能炼制产量加成"},
{SX="DanMake_YieldAddP",SXV = 0.05 ,SXP = 0 , SXname = "丹药炼制产量加值"},
{SX="PracticeRateAddPFromDan",SXV = 0 ,SXP = 0.05 , SXname = "瓶颈突破概率加成"},
{SX="WorldMapFlySpeedAddP",SXV = 0.03 ,SXP = 0 , SXname = "历练飞行速度"},
{SX="WorldMapFlySpeed",SXV = 0.03 ,SXP = 0 , SXname = "历练飞行速度加成"},
{SX="ExperienceNeckTimeCostCoefficient",SXV = 0 ,SXP = -0.01 , SXname = "历练瓶颈时间"},
{SX="NeckCountdownAddV",SXV = 280 ,SXP = 0 , SXname = "瓶颈倒计时推迟时间"},
{SX="AbilityLvAddV",SXV = -0.7 ,SXP = 0 , SXname = "道行加值"},
{SX="ExperiencePrestigeAddP",SXV = 0.05 ,SXP = 0 , SXname = "历练声望放大"},
{SX="ExperienceFindSpeedAddV",SXV = 0.03 ,SXP = 0 , SXname = "历练探索速度"},
{SX="NutritionToJingYuanK",SXV = 0 ,SXP = 0.05 , SXname = "精元获得率"},
{SX="NutritionWaterAutoRecover",SXV = 0 ,SXP = 0.05 , SXname = "饮气效率"},
{SX="NpcFight_ZhenKeyPointNum",SXV = 0.01 ,SXP = 0 , SXname = "阵法规模"},
{SX="NpcFight_ZhenEnginePower",SXV = 0.02 ,SXP = 0 , SXname = "阵法负荷能力"},
{SX="NpcFight_SneakValue",SXV = 0.03 ,SXP = 0 , SXname = "潜行值"},
};

local xueqism = ""
local wukongsm = ""
local ZhuanShuWuQilist = {
{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_luxueqi" , ZSName = "Item_zhuanshu_wuqi_luxueqi" , ModName = "Mod/Npc/LXQ/LXQ.FBX" , CHName = "天琊神女" , NPCName = "陆雪琪" , JSName = xueqism , SYName = "Item_zhuanshu_shangyi_luxueqi" , XYName = "Item_zhuanshu_xiayi_luxueqi" , SX1Name = "NpcFight_FabaoPowerAddP" , SX2Name = "NpcFight_SpellPowerAddP" , SXAddv = nil , SXAddp = "0.1" , XBName = g_emNpcSex.Male, FBName = "天琊神剑•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_sunwukong" , ZSName = "Item_zhuanshu_wuqi_sunqukong" , ModName = "Mod/Npc/SunWuKong/SunWuKong.FBX" , CHName = "齐天大圣" , NPCName = "孙悟空" , JSName = wukongsm , SYName = "Item_zhuanshu_shangyi_sunwukong" , XYName = "Item_zhuanshu_xiayi_sunwukong" , SX1Name = "NpcFight_ShieldConversionRateAddP" , SX2Name = "NpcFight_ShieldConversionRate" , SXAddv = nil , SXAddp = "0.09" , XBName = g_emNpcSex.Female, FBName = "如意金箍棒•[color=#D02090]伪[/color]"},

{WPjc = 0 , Fabao = "Item_zhuanshu_fabao_shangxinhua" , ZSName = "Item_zhuanshu_wuqi_hehuanling" , ModName = "Mod/Npc/BY/BY.FBX" , CHName = "碧瑶仙子" , NPCName = "碧瑶" , JSName = wukongsm , SYName = "Item_zhuanshu_shangyi_biyao" , XYName = "Item_zhuanshu_xiayi_biyao" , SX1Name = "NpcLingMaxValue" , SX2Name = "LingAbsorbSpeed" , SXAddv = nil , SXAddp = "0.095" , XBName = g_emNpcSex.Male, FBName = "伤心花•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_lvbu" , ZSName = "Item_zhuanshu_wuqi_lvbu" , ModName = "Mod/Npc/LvBu/LvBu.FBX" , CHName = "不败战神" , NPCName = "吕布" , JSName = wukongsm , SYName = "Item_zhuanshu_shangyi_lvbu" , XYName = "Item_zhuanshu_xiayi_lvbu" , SX1Name = "NpcFight_FabaoPowerAddP" , SX2Name = "NpcFight_ShieldConversionRateAddP" , SXAddv = nil , SXAddp = "0.085" , XBName = g_emNpcSex.Female, FBName = "方天画戟•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_libai" , ZSName = "Item_zhuanshu_wuqi_libai" , ModName = "Mod/Npc/LiBai/LiBai.FBX" , CHName = "青莲居士" , NPCName = "李白" , JSName = wukongsm , SYName = "Item_zhuanshu_shangyi_libai" , XYName = "Item_zhuanshu_xiayi_libai" , SX1Name = "MindStateBaseValue" , SX2Name = "WorldMapFlySpeedAddP" , SXAddv = 15 , SXAddp = "0.1" , XBName = g_emNpcSex.Female, FBName = "灵夙笔•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_yuji" , ZSName = "Item_zhuanshu_wuqi_yuji" , ModName = "Mod/Npc/YuJi/YuJi.FBX" , CHName = "死生契阔" , NPCName = "虞姬" , JSName = xueqism , SYName = "Item_zhuanshu_shangyi_yuji" , XYName = "Item_zhuanshu_xiayi_yuji" , SX1Name = "NpcFight_SpellPowerAddP" , SX2Name = "LingAbsorbSpeed" , SXAddv = nil , SXAddp = "0.1" , XBName = g_emNpcSex.Male, FBName = "流光舞月剑•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_diaochan" , ZSName = "Item_zhuanshu_wuqi_diaochan" , ModName = "Mod/Npc/DiaoChan/DiaoChan.FBX" , CHName = "闭月仙子" , NPCName = "貂蝉" , JSName = xueqism , SYName = "Item_zhuanshu_shangyi_diaochan" , XYName = "Item_zhuanshu_xiayi_diaochan" , SX1Name = "NpcFight_SpellPowerAddP" , SX2Name = "WorldMapFlySpeedAddP" , SXAddv = nil , SXAddp = "0.12" , XBName = g_emNpcSex.Male, FBName = "霓裳扇•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_zixia" , ZSName = "Item_zhuanshu_wuqi_zixia" , ModName = "Mod/Npc/ZiXia/ZiXia.FBX" , CHName = "紫霞仙子" , NPCName = "紫霞" , JSName = xueqism , SYName = "Item_zhuanshu_shangyi_zixia" , XYName = "Item_zhuanshu_xiayi_zixia" , SX1Name = "BaseEmotionAddV" , SX2Name = "NpcFight_SpellCastTimeAddP" , SXAddv = 20 , SXAddp = "-0.05" , XBName = g_emNpcSex.Male, FBName = "紫青宝剑•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_guanyu" , ZSName = "Item_zhuanshu_wuqi_guanyu" , ModName = "Mod/Npc/GuanYu/GuanYu.FBX" , CHName = "忠义无双" , NPCName = "关羽" , JSName = wukongsm , SYName = "Item_zhuanshu_shangyi_guanyu" , XYName = "Item_zhuanshu_xiayi_guanyu" , SX1Name = "NpcFight_ShieldConversionRateAddP" , SX2Name = "NpcFight_FabaoPowerAddP" , SXAddv = nil , SXAddp = "0.1" , XBName = g_emNpcSex.Female, FBName = "青龙偃月刀•[color=#D02090]伪[/color]"},

{WPjc = 1 , Fabao = "Item_zhuanshu_fabao_houyi" , ZSName = "Item_zhuanshu_wuqi_houyi" , ModName = "Mod/Npc/HouYi/HouYi.FBX" , CHName = "箭射九日" , NPCName = "后羿" , JSName = wukongsm , SYName = "Item_zhuanshu_shangyi_houyi" , XYName = "Item_zhuanshu_xiayi_houyi" , SX1Name = "ToleranceTMax" , SX2Name = "NpcFight_FabaoPowerAddP" , SXAddv = "10" , SXAddp = "0.12" , XBName = g_emNpcSex.Female, FBName = "射日神弓•[color=#D02090]伪[/color]"}
}


local JiLianCaiLiaolist = {
{CLName = "Item_Wood" ,						CLCount = 5000 ,	WPName = "Item_cailiao_muliao" ,	FJName = "Item_WoodLeftover" },					--原木
{CLName = "Item_HardWood" ,					CLCount = 200 ,		WPName = "Item_cailiao_muliao" ,	FJName = "Item_HardWoodLeftover" },					--金丝
{CLName = "Item_ParasolWood" , 				CLCount = 30 ,		WPName = "Item_cailiao_muliao" ,	FJName = "Item_ParasolWoodLeftover" },					--梧桐
{CLName = "Item_LingWood" ,					CLCount = 100 ,		WPName = "Item_cailiao_muliao" ,	FJName = "Item_LingWoodLeftover" },					--灵木
{CLName = "Item_cailiao_mucai0" ,			CLCount = 30 ,		WPName = "Item_cailiao_muliao" ,	FJName = nil },					--星髓
{CLName = "Item_cailiao_mucai1" ,			CLCount = 3 ,		WPName = "Item_cailiao_muliao1" ,	FJName = "Item_jiaoliao_mu1" },					--星髓
{CLName = "Item_cailiao_mucai2" ,			CLCount = 3 ,		WPName = "Item_cailiao_muliao2" ,	FJName = "Item_jiaoliao_mu2" },					--星髓
{CLName = "Item_cailiao_mucai3" ,			CLCount = 3 ,		WPName = "Item_cailiao_muliao3" ,	FJName = "Item_jiaoliao_mu3" },					--星髓
{CLName = "Item_cailiao_mucai4" ,			CLCount = 3 ,		WPName = "Item_cailiao_muliao4" ,	FJName = "Item_jiaoliao_mu4" },					--星髓
{CLName = "Item_cailiao_mucai5" ,			CLCount = 3 ,		WPName = "Item_cailiao_muliao5" ,	FJName = "Item_jiaoliao_mu5" },					--星髓
{CLName = "Item_cailiao_mucai6" ,			CLCount = 3 ,		WPName = "Item_cailiao_muliao6" ,	FJName = "Item_jiaoliao_mu6" },					--星髓
{CLName = "Item_cailiao_mucai7" ,			CLCount = 3 ,		WPName = "Item_cailiao_muliao7" ,	FJName = "Item_jiaoliao_mu7" },					--星髓

{CLName = "Item_BrownRock" ,				CLCount = 3000 ,	WPName = "Item_cailiao_shizhuan" ,	FJName = "Item_BrownRockLeftover" },					--棕石
{CLName = "Item_GrayRock" ,					CLCount = 2000 ,	WPName = "Item_cailiao_shizhuan" ,	FJName = "Item_GrayRockLeftover" },					--灰石
{CLName = "Item_Marble" ,					CLCount = 500  ,	WPName = "Item_cailiao_shizhuan" ,	FJName = "Item_MarbleLeftover" },					--大理石
{CLName = "Item_Jade" ,						CLCount = 200 ,		WPName = "Item_cailiao_shizhuan" ,	FJName = "Item_JadeLeftover" },					--玉石
{CLName = "Item_JadeEssence" , 				CLCount = 50 ,		WPName = "Item_cailiao_shizhuan" ,	FJName = nil },					--玉髓
{CLName = "Item_StoneEssence" ,				CLCount = 100 ,		WPName = "Item_cailiao_shizhuan" ,	FJName = nil },					--石髓
{CLName = "Item_SkyStone" , 				CLCount = 30 ,		WPName = "Item_cailiao_shizhuan" ,	FJName = "Item_SkyStoneLeftover" },					--天柱
{CLName = "Item_ExtremeJade" ,				CLCount = 30 ,		WPName = "Item_cailiao_shizhuan" ,	FJName = nil },					--千棱
{CLName = "Item_cailiao_shikuang0" ,		CLCount = 30 ,		WPName = "Item_cailiao_shizhuan" ,	FJName = nil },					--星髓
{CLName = "Item_cailiao_shikuang1" ,		CLCount = 3 ,		WPName = "Item_cailiao_shizhuan1" ,	FJName = "Item_jiaoliao_mu1" },					--星髓
{CLName = "Item_cailiao_shikuang2" ,		CLCount = 3 ,		WPName = "Item_cailiao_shizhuan2" ,	FJName = "Item_jiaoliao_mu2" },					--星髓
{CLName = "Item_cailiao_shikuang3" ,		CLCount = 3 ,		WPName = "Item_cailiao_shizhuan3" ,	FJName = "Item_jiaoliao_mu3" },					--星髓
{CLName = "Item_cailiao_shikuang4" ,		CLCount = 3 ,		WPName = "Item_cailiao_shizhuan4" ,	FJName = "Item_jiaoliao_mu4" },					--星髓
{CLName = "Item_cailiao_shikuang5" ,		CLCount = 3 ,		WPName = "Item_cailiao_shizhuan5" ,	FJName = "Item_jiaoliao_mu5" },					--星髓
{CLName = "Item_cailiao_shikuang6" ,		CLCount = 3 ,		WPName = "Item_cailiao_shizhuan6" ,	FJName = "Item_jiaoliao_mu6" },					--星髓
{CLName = "Item_cailiao_shikuang7" ,		CLCount = 3 ,		WPName = "Item_cailiao_shizhuan7" ,	FJName = "Item_jiaoliao_mu7" },					--星髓

{CLName = "Item_IronRock" ,					CLCount = 500 ,		WPName = "Item_cailiao_jinshu" ,	FJName = "Item_IronRockLeftover" },					--铁矿
{CLName = "Item_CopperRock" ,				CLCount = 200 ,		WPName = "Item_cailiao_jinshu" ,	FJName = "Item_CopperRockLeftover" },					--火铜
{CLName = "Item_SilverRock" ,				CLCount = 200 ,		WPName = "Item_cailiao_jinshu" ,	FJName = "Item_SilverRockLeftover" },					--寒晶
{CLName = "Item_DarksteelRock" ,			CLCount = 50 ,		WPName = "Item_cailiao_jinshu" ,	FJName = "Item_DarksteelRockLeftover" },					--玄铁
{CLName = "Item_StarEssence" ,				CLCount = 30 ,		WPName = "Item_cailiao_jinshu" ,	FJName = "Item_StarEssenceLeftover" },					--星髓
{CLName = "Item_cailiao_jinkuang0" ,		CLCount = 30 ,		WPName = "Item_cailiao_jinshu" ,	FJName = nil },					--星髓
{CLName = "Item_cailiao_jinkuang1" ,		CLCount = 3 ,		WPName = "Item_cailiao_jinshu1" ,	FJName = "Item_jiaoliao_mu1" },					--星髓
{CLName = "Item_cailiao_jinkuang2" ,		CLCount = 3 ,		WPName = "Item_cailiao_jinshu2" ,	FJName = "Item_jiaoliao_mu2" },					--星髓
{CLName = "Item_cailiao_jinkuang3" ,		CLCount = 3 ,		WPName = "Item_cailiao_jinshu3" ,	FJName = "Item_jiaoliao_mu3" },					--星髓
{CLName = "Item_cailiao_jinkuang4" ,		CLCount = 3 ,		WPName = "Item_cailiao_jinshu4" ,	FJName = "Item_jiaoliao_mu4" },					--星髓
{CLName = "Item_cailiao_jinkuang5" ,		CLCount = 3 ,		WPName = "Item_cailiao_jinshu5" ,	FJName = "Item_jiaoliao_mu5" },					--星髓
{CLName = "Item_cailiao_jinkuang6" ,		CLCount = 3 ,		WPName = "Item_cailiao_jinshu6" ,	FJName = "Item_jiaoliao_mu6" },					--星髓
{CLName = "Item_cailiao_jinkuang7" ,		CLCount = 3 ,		WPName = "Item_cailiao_jinshu7" ,	FJName = "Item_jiaoliao_mu7" },					--星髓
}


local JiangLilist = {
{	20	,"Item_zhuanshu_bianshen_1"		,5			},
{	5	,"Item_zaohua_tu_1"				,1			},
{	5	,"Item_zaohua_tu_2"				,1			},
{	5	,"Item_zaohua_tu_3"				,1			},
{	5	,"Item_zaohua_tu_4"				,1			},
{	5	,"Item_zaohua_tu_5"				,1			},
{	5	,"Item_zaohua_tu_6"				,1			},
{	5	,"Item_zaohua_tu_7"				,1			},
{	5	,"Item_zaohua_shui_1"			,1			},
{	5	,"Item_zaohua_shui_2"			,1			},
{	5	,"Item_zaohua_shui_3"			,1			},
{	5	,"Item_zaohua_shui_4"			,1			},
{	5	,"Item_zaohua_shui_5"			,1			},
{	5	,"Item_zaohua_shui_6"			,1			},
{	5	,"Item_zaohua_shui_7"			,1			},
{	5	,"Item_lingshi_jin1"			,1			},
{	5	,"Item_lingshi_mu1"				,1			},
{	5	,"Item_lingshi_shui1"			,1			},
{	5	,"Item_lingshi_huo1"			,1			},
{	5	,"Item_lingshi_jin1"			,1			},
{	5	,"Item_lingshi_tu1"				,1			},
{	5	,"Item_lingshi_yuan1"			,1			},
{	5	,"Item_lingshi_hun1"			,1			},
{	5	,"Item_cailiao_mucai1"			,1			},
{	5	,"Item_cailiao_mucai2"			,1			},
{	5	,"Item_cailiao_mucai3"			,1			},
{	5	,"Item_cailiao_mucai4"			,1			},
{	5	,"Item_cailiao_mucai5"			,1			},
{	5	,"Item_cailiao_mucai6"			,1			},
{	5	,"Item_cailiao_mucai7"			,1			},
{	5	,"Item_cailiao_shikuang1"		,1			},
{	5	,"Item_cailiao_shikuang2"		,1			},
{	5	,"Item_cailiao_shikuang3"		,1			},
{	5	,"Item_cailiao_shikuang4"		,1			},
{	5	,"Item_cailiao_shikuang5"		,1			},
{	5	,"Item_cailiao_shikuang6"		,1			},
{	5	,"Item_cailiao_shikuang7"		,1			},
{	5	,"Item_cailiao_jinkuang1"		,1			},
{	5	,"Item_cailiao_jinkuang2"		,1			},
{	5	,"Item_cailiao_jinkuang3"		,1			},
{	5	,"Item_cailiao_jinkuang4"		,1			},
{	5	,"Item_cailiao_jinkuang5"		,1			},
{	5	,"Item_cailiao_jinkuang6"		,1			},
{	5	,"Item_cailiao_jinkuang7"		,1			},
{	10	,"Item_qianghua_suipian1"		,3			},
{	10	,"Item_qianghua_suipian2"		,3			},
{	10	,"Item_qianghua_suipian3"		,3			},
{	10	,"Item_qianghua_suipian4"		,3			},
{	10	,"Item_qianghua_suipian5"		,3			},
{	10	,"Item_qianghua_suipian6"		,3			},
{	10	,"Item_qianghua_suipian7"		,3			},
{	10	,"Item_qianghua_suipian8"		,3			},
{	10	,"Item_qianghua_suipian9"		,3			},
{	10	,"Item_qianghua_suipian10"		,3			},
}

















function Table:GetCaiLiaoShuoMing(num)
	local mucailist =		{{"原木",5000,"随机"},{"金丝灵木",200,"随机"},{"灵木",100,"随机"},{"梧桐神木",30,"随机"},{"凤纹木屑",30,"随机"},{"凤纹木",3,"对应"}}
	local shicailist = 		{{"棕石",3000,"随机"},{"灰石",2000,"随机"},{"大理石",500,"随机"},{"玉石",200,"随机"},{"石髓",100,"随机"},{"玉髓",50,"随机"},{"天柱石",30,"随机"},{"千棱神玉",30,"随机"},{"螭吻碎玉",30,"随机"},{"螭吻玉",3,"对应"}}
	local kuangshilist = 	{{"铁矿",500,"随机"}, {"火铜矿石",200,"随机"},{"寒晶矿石",200,"随机"},{"玄铁矿石",50,"随机"},{"星髓",30,"随机"},{"龙纹碎金",30,"随机"},{"龙纹金",3,"对应"}}
	local list = {mucailist,shicailist,kuangshilist}
	
	local shuoming = ""
	local shuoming2 = ""
	if num == 1 then 
		shuoming = "[color=#458B74][size=12]"
		shuoming2 = "属性的凤纹灵材"
	elseif num == 2 then
		shuoming = "[color=#8B864E][size=12]"
		shuoming2 = "属性的螭吻玉晶"
	elseif num == 3 then
		shuoming = "[color=#B8860B][size=12]"
		shuoming2 = "属性的龙纹金精"
	end
	
	for k,v in pairs(list[num]) do
		shuoming = shuoming.."\n"..v[1]..v[2].."个产出一个"..v[3]..shuoming2
	end
	
	world:ShowMsgBox(shuoming, "祭炼配方")
end






function Table:GetTeShuFuWenlist()

local jin = {"NpcFight_ShieldResistanceToJin","NpcFight_ShieldResistanceToTu","NpcFight_ShieldResistanceToShui","NpcFight_FabaoFlySpeedAddP","NpcFight_FabaoMaxLingAddP","NpcFight_SpellCastTimeAddP","NpcFight_SpellCoolDownAddP","NpcFight_BaseHitChance","NpcFight_ZhenKeyPointNum"}
local mu = {"NpcFight_ShieldResistanceToMu","NpcFight_ShieldResistanceToShui","NpcFight_ShieldResistanceToHuo","LingAbsorbSpeed","NutritionToJingYuanK","NutritionWaterAutoRecover","MaxAccumulativeLingAddV","NpcFight_ZhenEnginePower"}
local shui = {"NpcFight_ShieldResistanceToShui","NpcFight_ShieldResistanceToJin","NpcFight_ShieldResistanceToMu","MindStateBaseValue","DanMake_SuccessRate","DanMake_SuccessRateAddV","DanMake_Yield","DanMake_SpeedAddV","DanMake_Speed","NpcFight_ZhenKeyPointNum"}
local huo = {"NpcFight_ShieldResistanceToHuo","NpcFight_ShieldResistanceToMu","NpcFight_ShieldResistanceToTu","FabaoMake_SpeedAddV","FabaoMake_SuccessRateAddV","FabaoMake_LingInheritRateAddV","FabaoMake_QualityAddV","FabaoMake_TwelveRateChance","NpcFight_ZhenEnginePower"}
local tu = {"NpcFight_ShieldResistanceToTu","NpcFight_ShieldResistanceToJin","NpcFight_ShieldResistanceToHuo","AbilityLvAddV","GodPenaltyAddV","NeckCountdownAddV","InspirationCoefficient","NpcFight_ZhenKeyPointNum"}

WorldLua:SetRandomSeed()
local jin1 = jin[WorldLua:RandomInt(1,#jin+1)]
local jin2 = jin[WorldLua:RandomInt(1,#jin+1)]
local mu1 = mu[WorldLua:RandomInt(1,#mu+1)]
local mu2 = mu[WorldLua:RandomInt(1,#mu+1)]
local shui1 = shui[WorldLua:RandomInt(1,#shui+1)]
local shui2 = shui[WorldLua:RandomInt(1,#shui+1)]
local huo1 = huo[WorldLua:RandomInt(1,#huo+1)]
local huo2 = huo[WorldLua:RandomInt(1,#huo+1)]
local tu1 = tu[WorldLua:RandomInt(1,#tu+1)]
local tu2 = tu[WorldLua:RandomInt(1,#tu+1)]
local wuxing = {jin1,mu1,shui1,huo1,tu1}
local wuxing1 = wuxing[WorldLua:RandomInt(1,#wuxing+1)]
local wuxing2 = wuxing[WorldLua:RandomInt(1,#wuxing+1)]

local shuxing1 = ShuXingList[WorldLua:RandomInt(1,#ShuXingList+1)].SX
local shuxing2 = ShuXingList[WorldLua:RandomInt(1,#ShuXingList+1)].SX
local TeShuFuWenlist = {
{"[color=#EEB422]亢金龙 • [/color]"	,"NpcLingMaxValue"						,jin1		,jin2		,shuxing1		,shuxing2		,"%[color=#EEB422%]亢金龙 • %[/color%]"},
{"[color=#7CFC00]角木蛟 • [/color]"	,"NpcLingMaxValue"						,mu1		,mu2		,shuxing1		,shuxing2		,"%[color=#7CFC00%]角木蛟 • %[/color%]"},			--东方青龙，灵气
{"[color=#87CEFA]箕水豹 • [/color]"	,"NpcLingMaxValue"						,shui1		,shui2		,shuxing1		,shuxing2		,"%[color=#87CEFA%]箕水豹 • %[/color%]"},
{"[color=#CD0000]尾火虎 • [/color]"	,"NpcLingMaxValue"						,huo1		,huo2		,shuxing1		,shuxing2		,"%[color=#CD0000%]尾火虎 • %[/color%]"},
{"[color=#CD8500]氐土貉 • [/color]"	,"NpcLingMaxValue"						,tu1		,tu2		,shuxing1		,shuxing2		,"%[color=#CD8500%]氐土貉 • %[/color%]"},
{"[color=#BFEFFF]房日兔 • [/color]"	,"NpcLingMaxValue"						,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#BFEFFF%]房日兔 • %[/color%]"},
{"[color=#A2B5CD]心月狐 • [/color]"	,"NpcLingMaxValue"						,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#A2B5CD%]心月狐 • %[/color%]"},


{"[color=#EEB422]鬼金羊 • [/color]"	,"NpcFight_SpellPowerAddP"				,jin1		,jin2		,shuxing1		,shuxing2		,"%[color=#EEB422%]鬼金羊 • %[/color%]"},
{"[color=#7CFC00]井木犴 • [/color]"	,"NpcFight_SpellPowerAddP"				,mu1		,mu2		,shuxing1		,shuxing2		,"%[color=#7CFC00%]井木犴 • %[/color%]"},			--南方朱雀，法术
{"[color=#87CEFA]轸水蚓 • [/color]"	,"NpcFight_SpellPowerAddP"				,shui1		,shui2		,shuxing1		,shuxing2		,"%[color=#87CEFA%]轸水蚓 • %[/color%]"},
{"[color=#CD0000]翼火蛇 • [/color]"	,"NpcFight_SpellPowerAddP"				,huo1		,huo2		,shuxing1		,shuxing2		,"%[color=#CD0000%]翼火蛇 • %[/color%]"},
{"[color=#CD8500]柳土獐 • [/color]"	,"NpcFight_SpellPowerAddP"				,tu1		,tu2		,shuxing1		,shuxing2		,"%[color=#CD8500%]柳土獐 • %[/color%]"},
{"[color=#BFEFFF]星日马 • [/color]"	,"NpcFight_SpellPowerAddP"				,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#BFEFFF%]星日马 • %[/color%]"},
{"[color=#A2B5CD]张月鹿 • [/color]"	,"NpcFight_SpellPowerAddP"				,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#A2B5CD%]张月鹿 • %[/color%]"},


{"[color=#EEB422]娄金狗 • [/color]"	,"NpcFight_FabaoPowerAddP"				,jin1		,jin2		,shuxing1		,shuxing2		,"%[color=#EEB422%]娄金狗 • %[/color%]"},
{"[color=#7CFC00]奎木狼 • [/color]"	,"NpcFight_FabaoPowerAddP"				,mu1		,mu2		,shuxing1		,shuxing2		,"%[color=#7CFC00%]奎木狼 • %[/color%]"},			--西方白虎，法宝
{"[color=#87CEFA]参水猿 • [/color]"	,"NpcFight_FabaoPowerAddP"				,shui1		,shui2		,shuxing1		,shuxing2		,"%[color=#87CEFA%]参水猿 • %[/color%]"},
{"[color=#CD0000]觜火猴 • [/color]"	,"NpcFight_FabaoPowerAddP"				,huo1		,huo2		,shuxing1		,shuxing2		,"%[color=#CD0000%]觜火猴 • %[/color%]"},
{"[color=#CD8500]胃土雉 • [/color]"	,"NpcFight_FabaoPowerAddP"				,tu1		,tu2		,shuxing1		,shuxing2		,"%[color=#CD8500%]胃土雉 • %[/color%]"},
{"[color=#BFEFFF]昴日鸡 • [/color]"	,"NpcFight_FabaoPowerAddP"				,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#BFEFFF%]昴日鸡 • %[/color%]"},
{"[color=#A2B5CD]毕月乌 • [/color]"	,"NpcFight_FabaoPowerAddP"				,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#A2B5CD%]毕月乌 • %[/color%]"},


{"[color=#EEB422]牛金牛 • [/color]"	,"NpcFight_ShieldConversionRateAddP"	,jin1		,jin2		,shuxing1		,shuxing2		,"%[color=#EEB422%]牛金牛 • %[/color%]"},
{"[color=#7CFC00]斗木獬 • [/color]"	,"NpcFight_ShieldConversionRateAddP"	,mu1		,mu2		,shuxing1		,shuxing2		,"%[color=#7CFC00%]斗木獬 • %[/color%]"},			--北方玄武，护盾
{"[color=#87CEFA]壁水貐 • [/color]"	,"NpcFight_ShieldConversionRateAddP"	,shui1		,shui2		,shuxing1		,shuxing2		,"%[color=#87CEFA%]壁水貐 • %[/color%]"},
{"[color=#CD0000]室火猪 • [/color]"	,"NpcFight_ShieldConversionRateAddP"	,huo1		,huo2		,shuxing1		,shuxing2		,"%[color=#CD0000%]室火猪 • %[/color%]"},
{"[color=#CD8500]女土蝠 • [/color]"	,"NpcFight_ShieldConversionRateAddP"	,tu1		,tu2		,shuxing1		,shuxing2		,"%[color=#CD8500%]女土蝠 • %[/color%]"},
{"[color=#BFEFFF]虚日鼠 • [/color]"	,"NpcFight_ShieldConversionRateAddP"	,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#BFEFFF%]虚日鼠 • %[/color%]"},
{"[color=#A2B5CD]危月燕 • [/color]"	,"NpcFight_ShieldConversionRateAddP"	,wuxing1	,wuxing2	,shuxing1		,shuxing2		,"%[color=#A2B5CD%]危月燕 • %[/color%]"},

}

	return TeShuFuWenlist
end










function Table:GetZhuanShuWuQilistTable()
	return ZhuanShuWuQilist
end

function Table:GetShuXinglistTable()
	return ShuXingList
end


function Table:GetJiLianCaiLiaolist()
	return JiLianCaiLiaolist
end


function Table:GetJiangLilist()
	return JiangLilist
end



function Table:GetBtn(thing,name)
	if thing.btns == nil then
		return false;
	end
	for i=0, thing.btns.Count -1 do
		if thing.btns[i].name == name then
			return thing.btns[i];
		end
	end
	return false
end



























