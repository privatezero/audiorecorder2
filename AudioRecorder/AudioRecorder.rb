# Recording Variables
FILTER_CHAIN = "asplit=6[out1][a][b][c][d][e],\
[e]showvolume=w=700:c=0xff0000:r=30[e1],\
[a]showfreqs=mode=bar:cmode=separate:size=300x300:colors=magenta|yellow[a1],\
[a1]drawbox=12:0:3:300:white@0.2[a2],[a2]drawbox=66:0:3:300:white@0.2[a3],[a3]drawbox=135:0:3:300:white@0.2[a4],[a4]drawbox=202:0:3:300:white@0.2[a5],[a5]drawbox=271:0:3:300:white@0.2[aa],\
[b]avectorscope=s=300x300:r=30:zoom=5[b1],\
[b1]drawgrid=x=150:y=150:c=white@0.3[bb],\
[c]showspectrum=s=400x600:slide=scroll:mode=combined:color=rainbow:scale=lin:saturation=4[cc],\
[d]astats=metadata=1:reset=1,adrawgraph=lavfi.astats.Overall.Peak_level:max=0:min=-30.0:size=700x256:bg=Black[dd],\
[dd]drawbox=0:0:700:42:hotpink@0.2:t=42[ddd],\
[aa][bb]vstack[aabb],[aabb][cc]hstack[aabbcc],[aabbcc][ddd]vstack[aabbccdd],[e1][aabbccdd]vstack[out0]"

sample_rate_choice = '96000'
sox_channels = '1 2'
ffmpeg_channels = 'stereo'
codec_choice = 'pcm_s24le'
soxbuffer = '50000'

Soxcommand = 'rec -r ' + sample_rate_choice + ' -b 32 -L -e signed-integer --buffer ' + soxbuffer + ' -p remix ' + sox_channels
FFmpegcommand = 'ffmpeg -channel_layout ' + ffmpeg_channels + ' -i - -f wav -c:a ' + codec_choice + ' -ar ' + sample_rate_choice + ' -'
Preview_FFmpegcommand = 'ffmpeg -channel_layout ' + ffmpeg_channels + ' -i - -f wav -c:a ' + 'pcm_s16le' + ' -ar ' + '44100' + ' -'
FFplaycommand = 'ffplay -window_title "AudioRecorder" -f lavfi ' + '"' + 'amovie=\'pipe\:0\'' + ',' + FILTER_CHAIN + '"'

# GUI App
Shoes.app(title: "Welcome to AudioRecorder", width: 400, height: 400) do
  stack margin: 10 do
    button "Edit Settings" do
      window(title: "A new window") do
        para "Please Make Selections"
        list_box items: ["44.1 kHz", "48 kHz", "96 kHz"]
      end
    end
  end

  stack margin: 10 do
    preview = button "Preview"
    preview.click do 
      command = Soxcommand + ' | ' + Preview_FFmpegcommand + ' | ' + FFplaycommand 
      system(command)
    end
    record = button "Record"
    exit = button "Quit"
  end
end