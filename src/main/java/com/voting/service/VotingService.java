package com.voting.service;

import com.voting.model.Candidate;
import com.voting.model.Election;
import com.voting.model.User;
import com.voting.model.Vote;
import com.voting.repository.CandidateRepository;
import com.voting.repository.ElectionRepository;
import com.voting.repository.UserRepository;
import com.voting.repository.VoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class VotingService {

    @Autowired
    private VoteRepository voteRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ElectionRepository electionRepository;

    @Autowired
    private CandidateRepository candidateRepository;

    @Transactional
    public Vote castVote(String userEmail, Long electionId, Long candidateId) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new IllegalArgumentException("Voter record not found for user: " + userEmail));

        Election election = electionRepository.findById(electionId)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + electionId));

        if (!"ACTIVE".equalsIgnoreCase(election.getStatus())) {
            throw new IllegalStateException("Voting is not open for this election. Status: " + election.getStatus());
        }

        if (voteRepository.existsByUserIdAndElectionId(user.getId(), electionId)) {
            throw new IllegalStateException("Duplicate Vote Alert: You have already cast your vote in this election.");
        }

        Candidate candidate = candidateRepository.findById(candidateId)
                .orElseThrow(() -> new IllegalArgumentException("Candidate not found: " + candidateId));

        if (!candidate.getElection().getId().equals(electionId)) {
            throw new IllegalArgumentException("Selected candidate does not belong to this election.");
        }

        // Save Vote record
        Vote vote = new Vote(user, election, candidate);
        Vote savedVote = voteRepository.save(vote);

        // Increment candidate vote tally
        candidate.incrementVoteCount();
        candidateRepository.save(candidate);

        return savedVote;
    }

    public boolean hasUserVotedInElection(Long userId, Long electionId) {
        return voteRepository.existsByUserIdAndElectionId(userId, electionId);
    }

    public Optional<Vote> getUserVoteForElection(Long userId, Long electionId) {
        return voteRepository.findByUserIdAndElectionId(userId, electionId);
    }

    public List<Vote> getVotesByUser(Long userId) {
        return voteRepository.findByUserId(userId);
    }

    public long getTotalVotesForElection(Long electionId) {
        return voteRepository.countByElectionId(electionId);
    }
}
