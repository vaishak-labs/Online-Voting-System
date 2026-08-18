package com.voting.config;

import com.voting.model.Candidate;
import com.voting.model.Election;
import com.voting.model.User;
import com.voting.repository.CandidateRepository;
import com.voting.repository.ElectionRepository;
import com.voting.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ElectionRepository electionRepository;

    @Autowired
    private CandidateRepository candidateRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Seed Admin Account
        if (!userRepository.existsByEmail("admin@voting.com")) {
            User admin = new User(
                    "ADM-00001",
                    "Election Chief Officer",
                    "admin@voting.com",
                    passwordEncoder.encode("admin123"),
                    "ROLE_ADMIN",
                    true
            );
            userRepository.save(admin);
        }

        // Seed Sample Voters
        if (!userRepository.existsByEmail("voter1@voting.com")) {
            User voter1 = new User(
                    "VOT-10001",
                    "Alex Mercer",
                    "voter1@voting.com",
                    passwordEncoder.encode("voter123"),
                    "ROLE_VOTER",
                    true
            );
            userRepository.save(voter1);
        }

        if (!userRepository.existsByEmail("voter2@voting.com")) {
            User voter2 = new User(
                    "VOT-10002",
                    "Sophia Lin",
                    "voter2@voting.com",
                    passwordEncoder.encode("voter123"),
                    "ROLE_VOTER",
                    true
            );
            userRepository.save(voter2);
        }

        // Seed Default Active Election & Candidates
        if (electionRepository.count() == 0) {
            Election election1 = new Election(
                    "2026 Presidential Election",
                    "National presidential election to vote for executive leadership and policy direction.",
                    "National",
                    LocalDateTime.now().minusDays(1),
                    LocalDateTime.now().plusDays(10),
                    "ACTIVE"
            );
            electionRepository.save(election1);

            Candidate c1 = new Candidate(
                    election1,
                    "Sarah Connor",
                    "Progressive Liberty Alliance",
                    "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80",
                    "Focusing on technological innovation, renewable energy infrastructure, and education access for all citizens."
            );
            c1.setVoteCount(14);

            Candidate c2 = new Candidate(
                    election1,
                    "Marcus Vance",
                    "National Economic Unity Party",
                    "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&auto=format&fit=crop&q=80",
                    "Promoting economic stabilization, small business incentives, and fiscal accountability across all sectors."
            );
            c2.setVoteCount(19);

            Candidate c3 = new Candidate(
                    election1,
                    "Elena Rostova",
                    "Independent Citizens Coalition",
                    "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&auto=format&fit=crop&q=80",
                    "Advocating for government transparency, digital privacy rights, and community-driven decision making."
            );
            c3.setVoteCount(8);

            candidateRepository.save(c1);
            candidateRepository.save(c2);
            candidateRepository.save(c3);

            // Second Election (Campus / Student Council)
            Election election2 = new Election(
                    "University Student Council Election 2026",
                    "Annual vote for Student Body President and Vice President representation.",
                    "Campus",
                    LocalDateTime.now().minusHours(5),
                    LocalDateTime.now().plusDays(3),
                    "ACTIVE"
            );
            electionRepository.save(election2);

            Candidate sc1 = new Candidate(
                    election2,
                    "David Miller & James Roy",
                    "Campus Forward Alliance",
                    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80",
                    "24/7 Library Access, upgraded campus dining, and expanded mental health wellness resources."
            );
            sc1.setVoteCount(42);

            Candidate sc2 = new Candidate(
                    election2,
                    "Priya Sharma & Liam Chen",
                    "Student Voice First",
                    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80",
                    "Affordable textbook initiatives, green campus zero-waste policy, and career mentorship programs."
            );
            sc2.setVoteCount(38);

            candidateRepository.save(sc1);
            candidateRepository.save(sc2);
        }
    }
}
