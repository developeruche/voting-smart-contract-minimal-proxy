// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract Vote {
    struct Candidate {
        address candidate;
        uint128 vote_count;
    }
    uint8 private election_id;
    string private postion_title;
    address private manager;
    Candidate[] private candidate_list;
    uint8 constant public max_no_of_candidate = 10;
    bool public started;
    bool public ended;
    uint256 public election_duration;
    mapping(address => bool) private has_voted;
    bool isInitialized;


    /// The contract has not been initalized, run the initalize function
    error HasNotBeenInit();

    /// You are not the election manager
    error NotManager();

    /// Election has not started 
    error ElectionNotStarted();

    /// Election has ended
    error ElectionHasEnded();

    /// Candidate must be at least two
    error AtLeastTwoCandidate();

    /// Candidates can not be more than ten
    error NotMoreThenTenCandidate();



    modifier hasNotBeenInit {
        if(!isInitialized) {
            revert HasNotBeenInit();
        }
      _;
   }

    modifier notManager {
        if(msg.sender == manager) {
            revert NotManager();
        }
      _;
   }

   modifier electionNotStarted {
        if(!started) {
            revert ElectionNotStarted();
        }
    _;
   }

   modifier electionHasEnded {
        if(ended) {
            revert ElectionHasEnded();
        }
    _;
   }

   modifier atLeastTwoCandidate {
        if(candidate_list.length < 2) {
            revert AtLeastTwoCandidate();
        }
    _;
   }


    event ElectionStarted(Candidate[] candidateList);
    event CandidateAdded(address[] newCandidates);


    /// @dev this function starts the election process
    function start() 
        public 
        hasNotBeenInit 
        notManager 
        atLeastTwoCandidate 
    {
        started = true;
        emit ElectionStarted(candidate_list);
    }

    /// @dev using this function the manager would be able to add candidates to the election
    function addCandidates(
        address[] memory _cand
    )
        public 
        notManager
        hasNotBeenInit
    {
        if(_cand.length > 10) {
            revert NotMoreThenTenCandidate();
        }

        // looping throught the candidate and storing in the array (candidate list)
        for(uint i = 0; i < _cand.length; i++) {
            // creating the candidate struct 
            Candidate memory ss = Candidate(_cand[i], 0);
            candidate_list.push(ss);
        }

        // emiting 
        emit CandidateAdded(_cand);
    }

    /// @dev cast vote (this is where the real voting happens)
}