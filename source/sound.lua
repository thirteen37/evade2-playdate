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

function MuteMusic(b)
  scoreChannel:setVolume(b and 0 or 1)
end

RAW_SOUNDS = {
  ["player_shoot"]={
    tempo=22,
    notes={
      {step=1, note="E5", length=11, velocity=110/128},
    },
    freq_mod=-1
  },
  ["enemy_shoot"]={
    tempo=22,
    notes={
      {step=1, note="E4", length=11, velocity=110/128},
    },
    freq_mod=1
  },
  ["player_hit"]={
    tempo=1,
    notes={
      {step=1, note="F3", length=2, velocity=128/128},
      {step=3, note="F2", length=2, velocity=128/128},
    }
  },
  ["next_attract_screen"]={
    tempo=1,
    notes={
      {step=0, note="C5", length=1, velocity=80/128},
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
SFX_CHANNELS = {}
for name, sfx in pairs(RAW_SOUNDS) do
  local sfxSynth = snd.synth.new(snd.kWaveSquare)
  local sfxInstrument = snd.instrument.new(sfxSynth)
  local sfxChannel = snd.channel.new()
  sfxChannel:addSource(sfxInstrument)
  local sfxTrack = snd.track.new()
  sfxTrack:setNotes(sfx.notes)
  sfxTrack:setInstrument(sfxInstrument)
  local sfxSequence = snd.sequence.new()
  sfxSequence:setTempo(sfx.tempo >= 8 and sfx.tempo or 8)
  sfxSequence:addTrack(sfxTrack)
  if sfx.freq_mod then
    local duration = sfxSequence:getLength() / sfxSequence:getTempo()
    local envelope = snd.envelope.new(duration, 0, 0, 0)
    envelope:setScale(sfx.freq_mod)
    envelope:setRetrigger(true)
    envelope:setOffset(1)
    sfxSynth:setFrequencyMod(envelope)
  end
  SOUNDS[name] = sfxSequence
  table.insert(SFX_CHANNELS, sfxChannel)
end

function PlaySound(s)
  local sfx = SOUNDS[s]
  if sfx:isPlaying() then
    sfx:goToStep(1)
  else
    sfx:play()
  end
end

function MuteSfx(b)
  for _, channel in pairs(SFX_CHANNELS) do
    channel:setVolume(b and 0 or 1)
  end
end
