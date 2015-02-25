# IOS

This is a grid UI-component.

It can support 2-D tableview scroll such as excel.

It implements auto-reuse horizontal cell for reducing memory-usage. (Non-ARC implementation)


**Usage///////////////////////////
If using ARC , then add complier flag "-fno-objc-arc" for no ARC compling. (TARGETS->Build Phases)
Adding Framework needed, Foundation.framework, UIKit.framework, QuartzCore.framework.
Apply TDGridView class to existing UITableView UI component.


** Class illustration/////////////
common.h :  change the cell size and others configuration

TDGridView :  the customized 2-D tableview scroll view

ProgramInfo :  the 2-D cell element layout and class configuration

TDGridViewDelegate :  implement customized horizontal axis (default is timeLine scale axis)


** Example file///////////////////

TDGridViewExample :  it's an example applied the "TDGridView"'



