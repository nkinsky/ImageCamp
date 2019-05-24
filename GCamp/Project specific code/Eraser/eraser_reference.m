% Eraser reference file

[MD, ref, ref2] = MakeMouseSessionListNK('Nat');

open = 0:2:12; shock = 1:2:13;

Marble3_shock = MD(ref.Marble3(1) + shock);
Marble3_open = MD(ref.Marble3(1) + open);
Marble3_all = MD(ref.Marble3(1):ref.Marble3(2));

Marble7_shock = MD(ref.Marble7(1) + shock);
Marble7_open = MD(ref.Marble7(1) + open);
Marble7_all = MD(ref.Marble7(1):ref.Marble7(2));