alias Converge.{Util, All}

defmodule RoleNvidia do
	require Util
	import Util, only: [conf_file: 1, conf_dir: 1]
	Util.declare_external_resources("files")

	def role(_tags \\ []) do
		%{
			desired_packages: [
				"xserver-xorg-legacy",
				"xserver-xorg-video-nvidia",

				"nvidia-driver-bin",
				"nvidia-kernel-dkms",
				"linux-headers-amd64",
				# For building DKMS modules with objtool / ORC unwinder
				"libelf-dev",
				"nvidia-opencl-icd",
				"nvidia-vdpau-driver",
				"nvidia-settings",
				"nvidia-smi",
				"nvidia-vulkan-common",

				# For --hwdec=cuda in mpv
				"libnvcuvid1",

				# For Steam, which needs all of these on NVIDIA
				"libdrm2:i386",
				"libgl1:i386",
				"libglx-nvidia0:i386",
			],
			post_install_unit: %All{units: [
				conf_dir("/etc/X11"),
				conf_dir("/etc/X11/xorg.conf.d"),
				conf_file("/etc/X11/xorg.conf.d/90-nvidia_i2c.conf"),
			]},
		}
	end
end
