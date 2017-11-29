alias Converge.Util

defmodule RoleNvidia do
	require Util
	Util.declare_external_resources("files")

	def role(tags \\ []) do
		release = Util.tag_value!(tags, "release") |> String.to_atom()
		case release do
			:xenial ->
				version = 384
				%{
					desired_packages: [
						"nvidia-#{version}",
						"libcuda1-#{version}",
						"nvidia-libopencl1-#{version}",
						"nvidia-opencl-icd-#{version}",
						"nvidia-settings",
					],
					apt_keys:    [Util.content("files/apt_keys/1118213C Launchpad PPA for Graphics Drivers Team.gpg")],
					apt_sources: ["deb http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu xenial main"],
				}
			:stretch ->
				%{
					desired_packages: [
						"xserver-xorg-legacy",
						"xserver-xorg-video-nvidia",

						"nvidia-driver-bin",
						"nvidia-kernel-dkms",
						"linux-headers-amd64",
						"nvidia-opencl-icd",
						"nvidia-vdpau-driver",
						"nvidia-settings",
						"nvidia-smi",

						# GLVND flavor, as per debian/nvidia-driver.README.Debian.in
						"libgl1-nvidia-glvnd-glx",
						"libgl1-glvnd-nvidia-glx",
						"nvidia-egl-icd",
						"libglx0-glvnd-nvidia",
						"libegl1-glvnd-nvidia",
						"nvidia-vulkan-common",

						# We don't want to lock with physlock because NVIDIA can't DPMS sleep
						# at a text-mode VT, and 387.34 can no longer properly reattach our 4K
						# DisplayPort monitor after it is power-cycled, so install xscreensaver
						# for screen locking.  Note that xscreensaver does not protect against
						# VT-switching.
						"xscreensaver",
					]
				}
		end
	end
end
