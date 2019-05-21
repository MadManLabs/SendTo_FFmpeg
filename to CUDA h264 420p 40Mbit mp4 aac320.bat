@ECHO OFF
setlocal enabledelayedexpansion

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
   set "argVn[!argCount!]=%%~nx"
)

SET "cmdp=%~dp0"
CALL "%cmdp%sendtoffmpeg_settings.cmd"

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.1 by Keerah.com                                 ---]
ECHO [---  Multi MP4 h264 module has been invoked                                   ---]
ECHO [---  Preset: CUDA 420 main 4.0, 40 Mbps, keyfr 2 sec, Audio AAC 320           ---]

IF %argCount% == 0 (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
	GOTO End
	)
	
IF %argCount% GTR 1 (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     %argCount% files queued to encode
	)
	
	FOR /L %%i IN (1,1,%argCount%) DO (
		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Transcoding %%i of %argCount%: !argVn[%%i]!
	"%ffpath%ffmpeg.exe" -v %vbl% -i "!argVec[%%i]!" -c:v h264_nvenc -profile:v main -preset slow -b:v 40M -pix_fmt yuv420p -force_key_frames 0:00:02 -c:a aac -b:a 320k -y "!argVn[%%i]!_cuda420_40Mbit_aac320.mp4"
	)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
if %pse% GTR 0 PAUSE

rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description insite it
rem This preset uses a separate Nvidia codec h264_nvenc.
rem For more information on the codec and its parameters refer to Nvidia's application note
rem https://developer.nvidia.com/designworks/dl/Using_FFmpeg_with_NVIDIA_GPU_Hardware_Acceleration-pdf
rem Just one hint from me on -b:v 40M argument, which defines the bitrate for the output.
rem The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02