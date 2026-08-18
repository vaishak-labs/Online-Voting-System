package com.voting.model;

import jakarta.persistence.*;

@Entity
@Table(name = "candidates")
public class Candidate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "election_id", nullable = false)
    private Election election;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 100)
    private String party;

    @Column(name = "symbol_url", length = 255)
    private String symbolUrl;

    @Column(columnDefinition = "TEXT")
    private String bio;

    @Column(name = "vote_count", nullable = false)
    private int voteCount = 0;

    public Candidate() {}

    public Candidate(Election election, String name, String party, String symbolUrl, String bio) {
        this.election = election;
        this.name = name;
        this.party = party;
        this.symbolUrl = symbolUrl;
        this.bio = bio;
        this.voteCount = 0;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Election getElection() { return election; }
    public void setElection(Election election) { this.election = election; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getParty() { return party; }
    public void setParty(String party) { this.party = party; }

    public String getSymbolUrl() { return symbolUrl; }
    public void setSymbolUrl(String symbolUrl) { this.symbolUrl = symbolUrl; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }

    public void incrementVoteCount() {
        this.voteCount++;
    }
}
