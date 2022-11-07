local snd <const> = playdate.sound

local synth = snd.synth.new(snd.kWaveSquare)
local instrument = snd.instrument.new(synth)
local sequence

function PlayScore(midiFile)
  if sequence and sequence:isPlaying() then
    sequence:stop()
  end
  sequence = snd.sequence.new(midiFile)
  for i = 1, sequence:getTrackCount() do
    sequence:getTrackAtIndex(i):setInstrument(instrument)
  end
  sequence:play()
end
