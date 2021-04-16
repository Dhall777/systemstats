defmodule SystemstatsWeb.MeminfoManpageLive do
  use SystemstatsWeb, :live_view
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
      <div class="row">
        <p><b>/proc/meminfo</b></p>
      </div>
        <p style="margin-left: 40px">This  file  reports  statistics about memory usage on the system.  It is used by free(1) to report the amount of free and used memory (both physical and swap) on the system as well as the shared memory and buffers used by  the  kernel. Each  line  of  the file consists of a parameter name, followed by a colon, the value of the parameter, and an option unit of measurement (e.g., "kB").  The list below describes the parameter names and the format specifier required  to read  the  field value.  Except as noted below, all of the fields have been present since at least Linux 2.6.0.  Some fields are displayed only if the kernel was configured with various options; those  dependencies  are  noted  in  the list.</p>
        <p><b>Active</b></p>
        <p style="margin-left: 40px">Memory that has been used more recently and usually not reclaimed unless absolutely necessary..
        <p><b>LowTotal</b></p>
        <p style="margin-left: 40px">(Starting with Linux 2.6.19, CONFIG_HIGHMEM is required.)  Total amount of lowmem.  Lowmem is memory which can be used for everything that highmem can be used for, but it is also available for the kernel's use for its own data  structures. Among many other things, it is where everything from Slab is allocated. BAD THINGS HAPPEN WHEN YOU ARE OUT OF LOWMEM.
        <p><b>LowFree</b></p>
        <p style="margin-left: 40px">(Starting with Linux 2.6.19, CONFIG_HIGHMEM is required.)  Amount of free lowmem.
        <p><b>HighTotal</b></p>
        <p style="margin-left: 40px">(Starting  with  Linux  2.6.19,  CONFIG_HIGHMEM is required.)  Total amount of highmem.  Highmem is all memory above ~860,000kB of physical memory.  Highmem areas are for use by user-space programs, or  for  the  page  cache. The kernel must use tricks to access this memory, making it slower to access than lowmem.
        <p><b>HighFree</b></p>
        <p style="margin-left: 40px">(Starting with Linux 2.6.19, CONFIG_HIGHMEM is required.)  Amount of free highmem.
      </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
