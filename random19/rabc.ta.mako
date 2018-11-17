/*
 A threshold automaton for probabilistic asynchronous Byzantine consensus
 by Gabriel Bracha.  Asynchronous Byzantine Agreement Protocols.
 In Information & Computation (1987) -- Figure 4, Protocol 2.

 This file is generated using mako templates. To produce a threshold automaton,
 do the following:

    - pip3 install Mako
    - ./generate-automata

 WARNING: THE .ta FILE HAS BEEN GENERATED. EDIT ONLY THE .ta.mako FILES

 Nathalie Bertrand, Igor Konnov, Marijana Lazic, Josef Widder, 2018.
 */

thresholdAutomaton Proc {
  /* the control locations are as follows:
    0 is the initial state with value 0 (V0),
    1 is the initial state with value 1 (V1),
    2 is the sent phase 1 messages (P1),
    3 is the sent phase 2 messages (P2),
    4 is the sent phase 3 messages (P3),
    5 is the decided 0 (D0),
    6 is the decided 1 (D1),
    7 is coin flip (CF),
    8 is estimate 0 (E0),
    9 is estimate 1 (E1),
    10 is phase 1 of the faulty process,
    11 is phase 2 of the faulty process,
    12 is phase 3 of the faulty process
   */
  local pc;
  /* the number of messages sent by the correct processes */
  shared s10, s11; /* 0s and 1s sent in phase 1 */
  shared s20, s21; /* 0s and 1s sent in phase 2 */
  shared s30, s31, s3bot; /* <d,0>, <d,1> as well as <0> and <1> in phase 3  */
  /* the number of messages sent by the faulty processes
     (the broadcast primitive turns Byzantine faults into 
     symmetric faults)
   */
  shared f10, f11, f20, f21, f30, f31, f3bot;

  parameters N, T, F;   /* nr of correct processes,
                           upper bound on f, and nr of Byzantine faults */

  assumptions (0) {
    N > 3 * T;
    T >= F;
    T >= 1;
  }

  locations (0) {
    locV0: [0]; locV1: [1];
    locP1: [2]; locP2: [3]; locP3: [4];
    locD0: [5]; locD1: [6];
    locCF: [7];
    locE0: [8]; locE1: [9];
    locFP1: [10]; locFP2: [11]; locFP3: [12]; locFP4: [13];
  }

  inits (0) {
    (locV0 + locV1) == N - F; locFP1 == F; 
    locP1 == 0; locP2 == 0; locP3 == 0;
    locD0 == 0; locD1 == 0;
    locCF == 0;
    locE0 == 0; locE1 == 0;
    locFP2 == 0; locFP3 == 0; locFP4 == 0;
    s10 == 0; s11 == 0;
    s20 == 0; s21 == 0;
    s30 == 0; s31 == 0; s3bot == 0;
    f10 == 0; f11 == 0; f20 == 0; f21 == 0;
    f30 == 0; f31 == 0; f3bot == 0;
  }

  rules (0) {
  /* send phase 3i + 1 messages */
  /* "Broadcast(p, 3i+1, value_p)." */
% for v in [0, 1]:
  1: locV${v} -> locP1
      when (true)
      do { s1${v}' == s1${v} + 1;
           unchanged(s1${1-v}, s20, s21, s30, s31, s3bot);
           unchanged(f10, f11, f20, f21, f30, f31, f3bot);
         };
% endfor

  /* receive phase 3i + 1 messages and send phase 3i + 2 messages */
  /* "Wait until validate n-t 3t+1 messages.
     value_p := majority of the n-t validated messages.
     Broadcast(p, 3i+2, value_p)."
   */
% for v in [0, 1]:
  2: locP1 -> locP2
      when (s10 + s11 + f10 + f11 >= N - T
            && 2 * (s1${v} + f1${v}) >= N - T)
      do { s2${v}' == s2${v} + 1;
           unchanged(s10, s11, s2${1-v}, s30, s31, s3bot);
           unchanged(f10, f11, f20, f21, f30, f31, f3bot);
         };
% endfor

  /* receive phase 3i + 2 messages and send phase 3i + 3 messages */
  /* "Wait until validate n-t 3t+2 messages.
     If more than n/2 of the messages have the same value v, then value = (d, v).
     Broadcast(p, 3i+2, value_p)."
   */
% for v in [0, 1]:
  3: locP2 -> locP3
      when (s20 + s21 + f20 + f21 >= N - T
            && 2 * (s2${v} + f2${v}) >= N + 1)
      do { s3${v}' == s3${v} + 1;
           unchanged(s10, s11, s20, s21, s3${1-v}, s3bot);
           unchanged(f10, f11, f20, f21, f30, f31, f3bot);
         };
% endfor

  /* wait until validate n-t 3t+2 messages.
     "If more than n/2 of the messages have the same value v => FALSE.
     Otherwise, value_p := value_p. (we just say bottom)
     Broadcast(p, 3i+2, value_p)."
   */
  4: locP2 -> locP3
      when (s20 + s21 + f20 + f21 >= N - T
            && 2 * (s20 + f20) >= N - 2 * T
            && 2 * (s21 + f21) >= N - 2 * T)
      do { s3bot' == s3bot + 1;
           unchanged(s10, s11, s20, s21, s30, s31);
           unchanged(f10, f11, f20, f21, f30, f31, f3bot);
         };


  /* receive phase 3i + 3 messages */
  /* "Wait until validate n-t 3t+3 messages.
     If validated more than 2t messages with value (d, v) then decision := value_p := v."
   */
% for v in [0, 1]:
  5: locP3 -> locD${v}
      when (s30 + s31 + s3bot + f30 + f31 + f3bot >= N - T
                && s3${v} + f3${v} >= 2 * T + 1)
      do {
        unchanged(s10, s11, s20, s21, s30, s31, s3bot);
        unchanged(f10, f11, f20, f21, f30, f31, f3bot);
      };
% endfor

  /* wait until validate n-t 3t+3 messages.
     "If validated more than 2t messages with value (d, v) => FALSE.
     If validated more than t messages with value (d, v) then value_p := v."
   */
% for v in [0, 1]:
  6: locP3 -> locE${v}
      when (s30 + s31 + s3bot + f30 + f31 + f3bot >= N - T
                && s3${v} + f3${v} >= T + 1
                && s3bot + f3bot > N - 5 * T)
      do {
        unchanged(s10, s11, s20, s21, s30, s31, s3bot);
        unchanged(f10, f11, f20, f21, f30, f31, f3bot);
      };
% endfor

  /* wait until validate n-t 3t+3 messages.
     "If validated more than 2t messages with value (d, v) => FALSE.
     If validated more than t messages with value (d, v) => FALSE.
     Otherwise, coin_toss (0 or 1 with probability 1/2)." Here, going to CF.
   */
  7: locP3 -> locCF
      when (s30 + s31 + s3bot + f30 + f31 + f3bot >= N - T
                && s3bot + f3bot > N - 3 * T)
      do {
        unchanged(s10, s11, s20, s21, s30, s31, s3bot);
        unchanged(f10, f11, f20, f21, f30, f31, f3bot);
      };

% for v in [0, 1]:
  8: locCF -> locE${v}
      when (true /* coin == ${v} */)
      do {
        unchanged(s10, s11, s20, s21, s30, s31, s3bot);
        unchanged(f10, f11, f20, f21, f30, f31, f3bot);
      };
% endfor

  /* faulty processes (pre-processed by Broadcast) */
% for v in [0, 1]:
  0: locFP1 -> locFP2
      when (true)
      do { f1${v}' == f1${v} + 1;
           unchanged(s10, s11, s20, s21, s30, s31, s3bot);
           unchanged(f1${1-v}, f20, f21, f30, f31, f3bot);
           };
% endfor
% for v in [0, 1]:
  0: locFP2 -> locFP3
      when (true)
      do { f2${v}' == f2${v} + 1;
           unchanged(s10, s11, s20, s21, s30, s31, s3bot);
           unchanged(f10, f11, f2${1-v}, f30, f31, f3bot);
           };
% endfor
% for v in [0, 1]:
  0: locFP3 -> locFP4
      when (true)
      do { f3${v}' == f3${v} + 1;
           unchanged(s10, s11, s20, s21, s30, s31, s3bot);
           unchanged(f10, f11, f20, f21, f3${1-v}, f3bot);
           };
% endfor
  0: locFP3 -> locFP4
      when (true)
      do { f3bot' == f3bot + 1;
           unchanged(s10, s11, s20, s21, s30, s31, s3bot);
           unchanged(f10, f11, f20, f21, f30, f31);
           };


  /* self loops */
% for phase in [1, 2, 3]:
  9: locP${phase} -> locP${phase}
      when (true)
      do {
        unchanged(s10, s11, s20, s21, s30, s31, s3bot);
        unchanged(f10, f11, f20, f21, f30, f31, f3bot);
      };
% endfor

% for v in [0, 1]:
  10: locD${v} -> locD${v}
      when (true)
      do {
        unchanged(s10, s11, s20, s21, s30, s31, s3bot);
        unchanged(f10, f11, f20, f21, f30, f31, f3bot);
      };
% endfor

% for v in [0, 1]:
  10: locE${v} -> locE${v}
      when (true)
      do {
        unchanged(s10, s11, s20, s21, s30, s31, s3bot);
        unchanged(f10, f11, f20, f21, f30, f31, f3bot);
      };
% endfor
  }
  specifications (0) {
    /* safety */

% for v in [0, 1]:
    validity${v}: (locV${1-v} == 0) -> [](locD${1-v} == 0 && locE${1-v} == 0);
% endfor

% for v in [0, 1]:
    agreement${v}: []((locD${v} != 0) -> [](locD${1-v} == 0 && locE${1-v} == 0));
% endfor

    round_term:
        <>[](  (s10 + s11 < N - T || locP1 == 0)
            && (s20 + s21 < N - T || locP2 == 0)
            && (s30 + s31 < N - T || locP3 == 0)
            && locV0 == 0 && locV1 == 0)
            ->
            <> (locV0 == 0 && locV1 == 0 && locP1 == 0 && locP2 == 0 && locP3 == 0);

% for v in [0, 1]:
    univalent2${v}:
        <>[](  (s10 + s11 < N - T || locP1 == 0)
            && (s20 + s21 < N - T || locP2 == 0)
            && (s30 + s31 < N - T || locP3 == 0)
            && locV0 == 0 && locV1 == 0)
        && (locV${1-v} == 0)
            -> <> (locD${v} != 0 || locE${v} != 0);
% endfor

  }
} /* Proc */


