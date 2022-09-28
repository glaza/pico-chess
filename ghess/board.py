
from square import Square as Sq

W = "white"
B = "black"

class Board:

    squares = [
        [Sq("a8", W), Sq("b8", B), Sq("c8", W), Sq("d8", B), Sq("e8", W), Sq("f8", B), Sq("g8", W), Sq("h8", B)],
        [Sq("a7", B), Sq("b7", W), Sq("c7", B), Sq("d7", W), Sq("e7", B), Sq("f7", W), Sq("g7", B), Sq("h7", W)],
        [Sq("a6", W), Sq("b6", B), Sq("c6", W), Sq("d6", B), Sq("e6", W), Sq("f6", B), Sq("g6", W), Sq("h6", B)],
        [Sq("a5", B), Sq("b5", W), Sq("c5", B), Sq("d5", W), Sq("e5", B), Sq("f5", W), Sq("g5", B), Sq("h5", W)],
        [Sq("a4", W), Sq("b4", B), Sq("c4", W), Sq("d4", B), Sq("e4", W), Sq("f4", B), Sq("g4", W), Sq("h4", B)],
        [Sq("a3", B), Sq("b3", W), Sq("c3", B), Sq("d3", W), Sq("e3", B), Sq("f3", W), Sq("g3", B), Sq("h3", W)],
        [Sq("a2", W), Sq("b2", B), Sq("c2", W), Sq("d2", B), Sq("e2", W), Sq("f2", B), Sq("g2", W), Sq("h2", B)],
        [Sq("a1", B), Sq("b1", W), Sq("c1", B), Sq("d1", W), Sq("e1", B), Sq("f1", W), Sq("g1", B), Sq("h1", W)],
    ]
