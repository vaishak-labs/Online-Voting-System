package com.voting.service;

import com.voting.model.Election;
import com.voting.repository.ElectionRepository;
import com.voting.repository.CandidateRepository;
import com.voting.repository.VoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ElectionService {

    @Autowired
    private ElectionRepository electionRepository;

    @Autowired
    private CandidateRepository candidateRepository;

    @Autowired
    private VoteRepository voteRepository;

    @Transactional
    public Election createElection(Election election) {
        if (election.getStartDate() == null) {
            election.setStartDate(LocalDateTime.now());
        }
        if (election.getEndDate() == null) {
            election.setEndDate(LocalDateTime.now().plusDays(7));
        }
        if (election.getStatus() == null || election.getStatus().isBlank()) {
            election.setStatus("ACTIVE");
        }
        return electionRepository.save(election);
    }

    @Transactional
    public Election updateElection(Long id, Election updatedDetails) {
        Election election = electionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + id));
        election.setTitle(updatedDetails.getTitle());
        election.setCategory(updatedDetails.getCategory());
        election.setDescription(updatedDetails.getDescription());
        if (updatedDetails.getStartDate() != null) {
            election.setStartDate(updatedDetails.getStartDate());
        }
        if (updatedDetails.getEndDate() != null) {
            election.setEndDate(updatedDetails.getEndDate());
        }
        if (updatedDetails.getStatus() != null && !updatedDetails.getStatus().isBlank()) {
            election.setStatus(updatedDetails.getStatus());
        }
        return electionRepository.save(election);
    }

    @Transactional
    public void deleteElection(Long id) {
        Election election = electionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + id));
        voteRepository.deleteByElectionId(id);
        candidateRepository.deleteByElectionId(id);
        electionRepository.delete(election);
    }

    public List<Election> getAllElections() {
        return electionRepository.findAllByOrderByStartDateDesc();
    }

    public List<Election> getActiveElections() {
        return electionRepository.findByStatus("ACTIVE");
    }

    public Optional<Election> getElectionById(Long id) {
        return electionRepository.findById(id);
    }

    @Transactional
    public void updateElectionStatus(Long id, String newStatus) {
        Election election = electionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + id));
        election.setStatus(newStatus.toUpperCase());
        electionRepository.save(election);
    }
}
