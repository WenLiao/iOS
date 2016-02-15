# iOS

<p><a href="https://github.com/WenLiao/IOS/blob/master/2D-Grid/demo.gif" target="_blank"><img src="https://github.com/WenLiao/IOS/blob/master/2D-Grid/demo.gif" alt="TDGridView_Demo_GIF" style="max-width:100%;"></a></p>


<h2>
<a id="user-content-TDGridView" class="anchor" href="#TDGridView" aria-hidden="true"><span class="octicon octicon-link"></span></a>TDGridView</h2>

This is a grid UI-component.

It can support 2-D tableview scroll such as excel.

It implements auto-reuse horizontal cell for reducing memory-usage. (Non-ARC implementation)



<h2>
<a id="user-content-usage" class="anchor" href="#usage" aria-hidden="true"><span class="octicon octicon-link"></span></a>Usage</h2>

If using ARC , then add complier flag "-fno-objc-arc" for no ARC compling. (TARGETS->Build Phases)
Adding Framework needed, Foundation.framework, UIKit.framework, QuartzCore.framework.
Apply TDGridView class to existing UITableView UI component.


<h2>
<a id="user-content-class_illus" class="anchor" href="#class-illus" aria-hidden="true"><span class="octicon octicon-link"></span></a>Class Illustration</h2>


common.h :  change the cell size and others configuration

TDGridView :  the customized 2-D tableview scroll view

ProgramInfo :  the 2-D cell element layout and class configuration

TDGridViewDelegate :  implement customized horizontal axis (default is timeLine scale axis)



<h2>
<a id="user-content-example" class="anchor" href="#example" aria-hidden="true"><span class="octicon octicon-link"></span></a>Example File</h2>

TDGridViewExample :  it's an example applied the "TDGridView"'

