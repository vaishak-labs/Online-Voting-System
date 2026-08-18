package com.voting.service;

import com.voting.model.Candidate;
import com.voting.model.Election;
import com.voting.model.User;
import com.voting.model.Vote;
import com.voting.repository.CandidateRepository;
import com.voting.repository.ElectionRepository;
import com.voting.repository.UserRepository;
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
class VotingServiceTest {

    @Mock
    private VoteRepository voteRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private ElectionRepository electionRepository;

    @Mock
    private CandidateRepository candidateRepository;

    @InjectMocks
    private VotingService votingService;

    private User user;
    private Election election;
    private Candidate candidate;

    @BeforeEach
    void setUp() {
        user = new User("VOT-10001", "Alex Mercer", "alex@voting.com", "pass", "ROLE_VOTER", true);
        user.setId(1L);

        election = new Election("2026 Presidential", "Desc", "National", null, null, "ACTIVE");
        election.setId(10L);

        candidate = new Candidate(election, "Sarah Connor", "Liberty Party", "url", "Bio");
        candidate.setId(100L);
        candidate.setVoteCount(5);
    }

    @Test
    void castVote_Success() {
        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(electionRepository.findById(election.getId())).thenReturn(Optional.of(election));
        when(voteRepository.existsByUserIdAndElectionId(user.getId(), election.getId())).thenReturn(false);
        when(candidateRepository.findById(candidate.getId())).thenReturn(Optional.of(candidate));
        when(voteRepository.save(any(Vote.class))).thenAnswer(inv -> inv.getArgument(0));

        Vote castVote = votingService.castVote(user.getEmail(), election.getId(), candidate.getId());

        assertNotNull(castVote);
        assertEquals(user, castVote.getUser());
        assertEquals(election, castVote.getElection());
        assertEquals(candidate, castVote.getCandidate());
        assertEquals(6, candidate.getVoteCount());

        verify(voteRepository, times(1)).save(any(Vote.class));
        verify(candidateRepository, times(1)).save(candidate);
    }

    @Test
    void castVote_DuplicateVote_ThrowsException() {
        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(electionRepository.findById(election.getId())).thenReturn(Optional.of(election));
        when(voteRepository.existsByUserIdAndElectionId(user.getId(), election.getId())).thenReturn(true);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () -> {
            votingService.castVote(user.getEmail(), election.getId(), candidate.getId());
        });

        assertTrue(ex.getMessage().contains("Duplicate Vote Alert"));
        verify(voteRepository, never()).save(any(Vote.class));
    }

    @Test
    void castVote_ClosedElection_ThrowsException() {
        election.setStatus("COMPLETED");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(electionRepository.findById(election.getId())).thenReturn(Optional.of(election));

        IllegalStateException ex = assertThrows(IllegalStateException.class, () -> {
            votingService.castVote(user.getEmail(), election.getId(), candidate.getId());
        });

        assertTrue(ex.getMessage().contains("Voting is not open"));
        verify(voteRepository, never()).save(any(Vote.class));
    }
}
