function outputLetter = imcompare(letter, height, width)

% iterate over a dataset, resize the dataset's image to 
% compare = imresize(letter, height, width);
% any value that has less than 50 pixels left is returned as the name.

load letterdatabase;

% check order is A-Z Dash 0-9
compared = zeros(36,1);

compared(1) = imresize(A, height, width);
compared(2) = imresize(B, height, width);
compared(3) = imresize(C, height, width);
compared(4) = imresize(D, height, width);
compared(5) = imresize(E, height, width);
compared(6) = imresize(F, height, width);
compared(7) = imresize(G, height, width);
compared(8) = imresize(H, height, width);
compared(9) = imresize(I, height, width);
compared(10) = imresize(J, height, width);
compared(11) = imresize(K, height, width);
compared(12) = imresize(L, height, width);
compared(13) = imresize(M, height, width);
compared(14) = imresize(N, height, width);
compared(15) = imresize(O, height, width);
compared(16) = imresize(P, height, width);
compared(17) = imresize(Q, height, width);
compared(18) = imresize(R, height, width);
compared(19) = imresize(S, height, width);
compared(20) = imresize(T, height, width);
compared(21) = imresize(U, height, width);
compared(22) = imresize(V, height, width);
compared(23) = imresize(W, height, width);
compared(24) = imresize(X, height, width);
compared(25) = imresize(Z, height, width);
compared(26) = imresize(Dash, height, width);
compared(27) = imresize(Num0, height, width);
compared(28) = imresize(Num1, height, width);
compared(29) = imresize(Num2, height, width);
compared(30) = imresize(Num3, height, width);
compared(31) = imresize(Num4, height, width);
compared(32) = imresize(Num5, height, width);
compared(33) = imresize(Num6, height, width);
compared(34) = imresize(Num7, height, width);
compared(35) = imresize(Num8, height, width);
compared(36) = imresize(Num9, height, width);