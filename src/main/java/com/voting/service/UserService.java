package com.voting.service;

import com.voting.dto.RegistrationDto;
import com.voting.model.User;
import com.voting.repository.UserRepository;
import com.voting.repository.VoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VoteRepository voteRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional
    public User registerVoter(RegistrationDto dto) {
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("Email address is already registered.");
        }
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new IllegalArgumentException("Password and confirm password do not match.");
        }

        String voterId = generateUniqueVoterId();
        User user = new User();
        user.setVoterId(voterId);
        user.setFullName(dto.getFullName());
        user.setEmail(dto.getEmail());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setRole("ROLE_VOTER");
        user.setVerified(true); // Auto-verify for active demo convenience

        return userRepository.save(user);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> findByVoterId(String voterId) {
        return userRepository.findByVoterId(voterId);
    }

    public List<User> getAllVoters() {
        return userRepository.findByRole("ROLE_VOTER");
    }

    @Transactional
    public void toggleVerification(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));
        user.setVerified(!user.isVerified());
        userRepository.save(user);
    }

    @Transactional
    public void deleteVoter(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));
        if ("ROLE_ADMIN".equals(user.getRole())) {
            throw new IllegalArgumentException("Cannot delete Administrator account.");
        }
        voteRepository.deleteByUserId(userId);
        userRepository.delete(user);
    }

    private String generateUniqueVoterId() {
        Random random = new Random();
        String voterId;
        do {
            int num = 10000 + random.nextInt(90000);
            voterId = "VOT-" + num;
        } while (userRepository.existsByVoterId(voterId));
        return voterId;
    }
}
