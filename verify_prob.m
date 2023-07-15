function [qa_prob, qb_prob] = verify_prob(qas,qbs)

    qa_prob = zeros([2, 1]);
    qb_prob = zeros([2, 1]);
    for i=1:numel(qas)
        if qas(i) == 1
            qa_prob(1) = qa_prob(1) +1;
        else
            qa_prob(2) = qa_prob(2) +1;
        end
        if qbs(i) == 1
            qb_prob(1) = qb_prob(1) +1;
        else
            qb_prob(2) = qb_prob(2) +1;
        end
    end
    qa_prob = qa_prob/numel(qas);
    qb_prob = qb_prob/numel(qas);
end

