local snd <const> = playdate.sound

local synth = snd.synth.new(snd.kWaveSquare)
local instrument = snd.instrument.new(synth)

function PlayScore(midiFile)
  local sequence = snd.sequence.new(midiFile)
  for i = 1, sequence:getTrackCount() do
    sequence:getTrackAtIndex(i):setInstrument(instrument)
  end
  sequence:play()
end
