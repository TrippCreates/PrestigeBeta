// Initialize Firebase
const firebaseConfig = {
    apiKey: "AIzaSyCgxzVVdq-bgzpuX_-J9hxCg3E9yu2G1KA",
    authDomain: "email-collector-84919.firebaseapp.com",
    projectId: "email-collector-84919",
    storageBucket: "email-collector-84919.firebasestorage.app",
    messagingSenderId: "300058104825",
    appId: "1:300058104825:ios:2b41bc0d5770d46888a328"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();

// Function to add email to waitlist
async function addToWaitlist(email) {
    try {
        // Add email to waitlist collection
        await db.collection('waitlist').add({
            email: email,
            timestamp: firebase.firestore.FieldValue.serverTimestamp(),
            status: 'pending'
        });
        return { success: true, message: 'Successfully added to waitlist!' };
    } catch (error) {
        console.error('Error adding to waitlist:', error);
        return { success: false, message: 'Error adding to waitlist. Please try again.' };
    }
}

// Function to validate email
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

// Handle form submission
document.getElementById('waitlistForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const emailInput = document.getElementById('email');
    const email = emailInput.value.trim();
    const submitButton = document.getElementById('submitButton');
    const statusMessage = document.getElementById('statusMessage');
    
    // Validate email
    if (!validateEmail(email)) {
        statusMessage.textContent = 'Please enter a valid email address.';
        statusMessage.className = 'error';
        return;
    }
    
    // Disable submit button and show loading state
    submitButton.disabled = true;
    submitButton.textContent = 'Adding...';
    statusMessage.textContent = '';
    
    // Add to waitlist
    const result = await addToWaitlist(email);
    
    // Update UI based on result
    if (result.success) {
        statusMessage.textContent = result.message;
        statusMessage.className = 'success';
        emailInput.value = '';
    } else {
        statusMessage.textContent = result.message;
        statusMessage.className = 'error';
    }
    
    // Re-enable submit button
    submitButton.disabled = false;
    submitButton.textContent = 'Join Waitlist';
}); 