function [q_n] = verify_prob(qas,qbs)

    q_n = zeros([4, 1]);
    state = [qas(1), 1-qas(1), qbs(1), 1-qbs(1)];
    for i=2:numel(qas)
        new_state = [qas(i), 1-qas(i), qbs(i), 1-qbs(i)];
        tr = xor(state, new_state);
        q_n = q_n + tr';
        state = new_state;
    end
end

