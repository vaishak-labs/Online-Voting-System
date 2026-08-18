package com.voting.service;

import com.voting.model.User;
import com.voting.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String usernameOrEmailOrVoterId) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(usernameOrEmailOrVoterId)
                .orElseGet(() -> userRepository.findByVoterId(usernameOrEmailOrVoterId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with identifier: " + usernameOrEmailOrVoterId)));

        if (!user.isVerified()) {
            throw new RuntimeException("Account is not verified yet. Please contact election admin.");
        }

        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority(user.getRole()))
        );
    }
}
