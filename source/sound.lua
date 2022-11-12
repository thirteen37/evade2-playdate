local snd <const> = playdate.sound

local synth = snd.synth.new(snd.kWaveSquare)
local instrument = snd.instrument.new(synth)
local scoreChannel = snd.channel.new()
scoreChannel:addSource(instrument)
local sequence

function PlayScore(midiFile)
  if sequence and sequence:isPlaying() then
    local s = sequence
    sequence = nil
    s:stop()
  end
  sequence = snd.sequence.new(midiFile)
  for i = 1, sequence:getTrackCount() do
    sequence:getTrackAtIndex(i):setInstrument(instrument)
  end
  function replay(s)
    if not s or sequence == s then
      sequence:play(replay)
    end
  end
  replay()
end

RAW_SOUNDS = {
  ["player_shoot"]={
    tempo=22,
    notes={
      {step=1, note="E5", length=11, volume=110/128},
    }
  },
  ["enemy_shoot"]={
    tempo=22,
    notes={
      {step=1, note="E4", length=11, volume=110/128},
    }
  },
  ["player_hit"]={
    tempo=1,
    notes={
      {step=1, note="F3", length=2, volume=128/128},
      {step=3, note="F2", length=2, volume=128/128},
    }
  },
  ["next_attract_screen"]={
    tempo=1,
    notes={
      {step=0, note="C5", length=1, volume=80/128},
      {step=1, note="E5", length=2, velocity=80/128},
    }
  },
  ["next_attract_char"]={
    tempo=1,
    notes={
      {step=1, note="D5", length=1, velocity=80/128},
    }
  },
}
SOUNDS = {}
for name, sfx in pairs(RAW_SOUNDS) do
  local sfxSynth = snd.synth.new(snd.kWaveSquare)
  local sfxInstrument = snd.instrument.new(sfxSynth)
  local sfxChannel = snd.channel.new()
  sfxChannel:addSource(sfxInstrument)
  local sfxTrack = snd.track.new()
  sfxTrack:setNotes(sfx.notes)
  sfxTrack:setInstrument(sfx.instrument or sfxInstrument)
  local sfxSequence = snd.sequence.new()
  sfxSequence:setTempo(sfx.tempo >= 8 and sfx.tempo or 8)
  sfxSequence:addTrack(sfxTrack)
  SOUNDS[name] = sfxSequence
end

function PlaySound(s)
  local sfx = SOUNDS[s]
  if sfx:isPlaying() then
    sfx:goToStep(1)
  else
    sfx:play()
  end
end
