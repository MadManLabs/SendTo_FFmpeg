@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2020 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                ---]
ECHO [---  audio muxing module has been invoked, this preset is single file only    ---]                                     ---]
ECHO [---  Preset: Video copy, Mux external mp3 Audio to aac256                     ---]
ECHO [---  Using external audio source file: %~n1.mp3

SET "cmdp=%~dp0"
SET "argp=%~dp1"

IF EXIST "%argp%sendtoffmpeg_settings.cmd" ( 
	CALL "%argp%sendtoffmpeg_settings.cmd"
	ECHO [---  Settings: LOCAL                                                          ---]
) ELSE (
	CALL "%cmdp%sendtoffmpeg_settings.cmd"
	ECHO [---  Settings: GLOBAL                                                         ---]
)

IF %1.==. (

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]

) ELSE (

	IF not EXIST "%~n1.mp3" (

		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Couldn't find the external audio file: %~n1.wav
		GOTO End
	)	

	IF %dscr% GTR 0 (SET "dscrName=_mux_aac256") ELSE (SET "dscrName=")

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                              ]
	
	for /F "delims=" %%f in ('call "%ffpath%ffprobe.exe" -v error -show_entries "format=duration" -of "default=noprint_wrappers=1:nokey=1" "!argVec[%%i]!"') do echo [     Video length is: %%f

	"%ffpath%ffmpeg.exe" -v %vbl% -hide_banner -stats -i %1 -i "%~n1.mp3" -codec copy -c:a aac -b:a 256k -shortest -y "%~n1!%dscrName%.mp4"
)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]

IF %pse% GTR 0 PAUSE

rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description inside it
rem This batch looks for a .wav file with the same name as your source video has
rem and places it instead of whatever audio was in your source video.
rem If the streams are different in length the arg -shortest tells FFmpeg
rem to cut the output to the shortest of audio or video.
rem New audio will be compressed into 256kbps AAC, the video stream is copied (no recompression).
rem FFmpeg is clever and takes in account all the source audio channels.
rem This script does not support muliple files 