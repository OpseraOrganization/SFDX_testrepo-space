// Interface to switch between ROTA and schedule
public interface CH_CA_Iavailability {
	// Get the available workgroup members 
	List<CH_CA_DTO.WorkgroupMemberDTO> filterWorkgroupMembersByAvailability(List<CH_CA_DTO.WorkgroupMemberDTO> allWorkgroupMembers);
}