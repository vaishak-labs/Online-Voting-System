package com.voting.service;

import com.voting.model.Candidate;
import com.voting.model.Election;
import com.voting.repository.CandidateRepository;
import com.voting.repository.ElectionRepository;
import com.voting.repository.VoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CandidateService {

    @Autowired
    private CandidateRepository candidateRepository;

    @Autowired
    private ElectionRepository electionRepository;

    @Autowired
    private VoteRepository voteRepository;

    @Transactional
    public Candidate addCandidateToElection(Long electionId, Candidate candidate) {
        Election election = electionRepository.findById(electionId)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + electionId));
        candidate.setElection(election);
        return candidateRepository.save(candidate);
    }

    @Transactional
    public Candidate updateCandidate(Long candidateId, Candidate updatedDetails) {
        Candidate candidate = candidateRepository.findById(candidateId)
                .orElseThrow(() -> new IllegalArgumentException("Candidate not found: " + candidateId));
        candidate.setName(updatedDetails.getName());
        candidate.setParty(updatedDetails.getParty());
        candidate.setSymbolUrl(updatedDetails.getSymbolUrl());
        candidate.setBio(updatedDetails.getBio());
        return candidateRepository.save(candidate);
    }

    @Transactional
    public void deleteCandidate(Long candidateId) {
        Candidate candidate = candidateRepository.findById(candidateId)
                .orElseThrow(() -> new IllegalArgumentException("Candidate not found: " + candidateId));
        voteRepository.deleteByCandidateId(candidateId);
        candidateRepository.delete(candidate);
    }

    public List<Candidate> getCandidatesByElection(Long electionId) {
        return candidateRepository.findByElectionId(electionId);
    }

    public List<Candidate> getCandidatesSortedByVotes(Long electionId) {
        return candidateRepository.findByElectionIdOrderByVoteCountDesc(electionId);
    }

    public Optional<Candidate> getCandidateById(Long candidateId) {
        return candidateRepository.findById(candidateId);
    }
}
