###################################################################################################
# 3. Clock groups
#
# * Filename    : clock_groups.tcl
# * Command     : set_clock_groups
# * Description : Specify clock groups that are mutually exclusive or asynchronous with each other
#                 in a design so that the paths between these clocks are not considered during
#                 the timing analysis 
#
# * Please fill in the all clock groups by using clock name.
#
# [NOTE] 
# 1. Please keep the group naming convention
# 
#           GRP_${CKBLK_HIER}_GroupName
#
# 2. When user declare set_clock_groups, "-name group_name" must be used
#
# 3. When using "-group" option in set_clock_groups command,
#    don't use just one "-group" option and use more than 2 "-group" options 
#  
# 4. You should check if "set_clock_groups" uses "allow_paths" option or not.
#    And, if you make "set_clock_groups" constraints by yourself, 
#    Please add "allow_paths" in the following situation. 
#    (ex)
#    if you use "set_max_delay -from CLK_A -to CLK_B"
#    Then, you should add "allow_paths" option in "set_clock_groups" as following.
#    "set_clock_groups -async -group CLK_A -group CLK_B -allow_paths"
# 
###################################################################################################


puts "\n3. Clock groups"
set_clock_groups -asynchronous -name CLOCK -group PCLK -group ACLK -allow_paths