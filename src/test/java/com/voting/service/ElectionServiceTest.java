package com.voting.service;

import com.voting.model.Election;
import com.voting.repository.CandidateRepository;
import com.voting.repository.ElectionRepository;
import com.voting.repository.VoteRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ElectionServiceTest {

    @Mock
    private ElectionRepository electionRepository;

    @Mock
    private CandidateRepository candidateRepository;

    @Mock
    private VoteRepository voteRepository;

    @InjectMocks
    private ElectionService electionService;

    private Election election;

    @BeforeEach
    void setUp() {
        election = new Election("Campus Council 2026", "Desc", "Campus", null, null, "ACTIVE");
        election.setId(1L);
    }

    @Test
    void createElection_PopulatesDefaults() {
        when(electionRepository.save(any(Election.class))).thenAnswer(inv -> inv.getArgument(0));

        Election created = electionService.createElection(election);

        assertNotNull(created.getStartDate());
        assertNotNull(created.getEndDate());
        assertEquals("ACTIVE", created.getStatus());
        verify(electionRepository, times(1)).save(election);
    }

    @Test
    void updateElectionStatus_Success() {
        when(electionRepository.findById(1L)).thenReturn(Optional.of(election));

        electionService.updateElectionStatus(1L, "completed");

        assertEquals("COMPLETED", election.getStatus());
        verify(electionRepository, times(1)).save(election);
    }

    @Test
    void deleteElection_DeletesVotesAndCandidatesFirst() {
        when(electionRepository.findById(1L)).thenReturn(Optional.of(election));

        electionService.deleteElection(1L);

        verify(voteRepository, times(1)).deleteByElectionId(1L);
        verify(candidateRepository, times(1)).deleteByElectionId(1L);
        verify(electionRepository, times(1)).delete(election);
    }
}
