package com.voting.repository;

import com.voting.model.Vote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VoteRepository extends JpaRepository<Vote, Long> {
    boolean existsByUserIdAndElectionId(Long userId, Long electionId);
    Optional<Vote> findByUserIdAndElectionId(Long userId, Long electionId);
    List<Vote> findByUserId(Long userId);
    long countByElectionId(Long electionId);
    long countByCandidateId(Long candidateId);
    void deleteByUserId(Long userId);
    void deleteByElectionId(Long electionId);
    void deleteByCandidateId(Long candidateId);
}
