function verify_switching(qa,qb)

    state = [qa(1), qb(1)];
    for i=2:numel(qa)
        state_new = [qa(i), qb(i)];
        if sum(xor(state, state_new) >= 2)
            errID = 'MYFUN:badstate';
            baseException = MException(errID,'wrong transition');
            throw(baseException);
        end
        state = state_new;
    end
end

