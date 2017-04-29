use Mix.Config

config :ex_junk,
  phone: [Integer, [size: 10]],
  ssn: &JunkTest.ssn/0,
  color: &JunkTest.color/0
